Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55EF436D5B
	for <lists+ceph-devel@lfdr.de>; Fri, 22 Oct 2021 00:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbhJUWW6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 Oct 2021 18:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbhJUWW5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 21 Oct 2021 18:22:57 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21021C061243
        for <ceph-devel@vger.kernel.org>; Thu, 21 Oct 2021 15:20:41 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so1645726pjb.0
        for <ceph-devel@vger.kernel.org>; Thu, 21 Oct 2021 15:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tSebnyNuofgB+vH+7uyEvZ4tUVxD1t6yZgP5DdCdt6U=;
        b=F7yvuj7nSVzEl2W8Oqbp8atFxmQ6r9Dbqs8V0fbJgxGY00MyLd4k7jqKWORSw8mHY3
         IxDvRVo4cDtbcTi+/kKA0Egwg6fwcXP4oiOtpnrGNLmO/C442vDZiAmDs7CTs8KbHnL0
         kCfPRr95kbaIPqVIEMaFt3kyXUmXLF1FErwp9s/A5nE3+S3NMzLTtwdHdwqBgOjYLvX6
         WYBTP6OervOJQWbY/Vx42YzjOvR/cqpxNWYc3dmwBm4LRWFBE/nHVqb6lPrrGCjmZ/nt
         d5x2bQUiW2+vfgaGS/ipy/W+4F2BD7/kMrpChjIWchBsBRmebimx5o7b+OPOqd72o4oe
         ThBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tSebnyNuofgB+vH+7uyEvZ4tUVxD1t6yZgP5DdCdt6U=;
        b=Y2rSVBtccB+c5Gl/R0Ce1qRRVjYHufkNeu/FZmrpTGFEWG6ufCullXcYmoLqE7oQVn
         fWJEKwdCHROuhratWil/uAdW8zavEvvoTZRCy9xboHaaRUHLX01NOJ8+lkRm+NamLcOH
         aSwpbEKYLa/JHV/UCEHN1MN7irKzn4R9qKoF0kE5UmsKzCXeKg5OaDm0gj0V71UJCAIo
         CjWnHyqvcbaFMoDoLVNd0WwA+VqHBOmwFNLrEapqsk3qQHemHiAaUh/gL1zuQtl4kViF
         hcGiwybwHTSDCLzXa2x0Bn0485uiuguAaWSaqRJAAnxKtz8x9UdAIQBgdojJ6RQLwJ1P
         UMKg==
X-Gm-Message-State: AOAM530KVhZIJxCkl6WdAcK+hUBfmm00rHK1OG8m+yNoK25sXo+eyZ5U
        XZVusoaytbaLSL++XdZBB5OGKw==
X-Google-Smtp-Source: ABdhPJwPCYMB5mXDn/964xDyH1fZwMCe0wUF+PkkOcGHAMNid1VUJ2pJtdpAOgiix5LMUW5jc9KZFg==
X-Received: by 2002:a17:90b:1041:: with SMTP id gq1mr9693769pjb.31.1634854840491;
        Thu, 21 Oct 2021 15:20:40 -0700 (PDT)
Received: from relinquished.localdomain ([2620:10d:c090:400::5:69a9])
        by smtp.gmail.com with ESMTPSA id n22sm6962317pjv.22.2021.10.21.15.20.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 15:20:40 -0700 (PDT)
Date:   Thu, 21 Oct 2021 15:20:36 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     David Howells <dhowells@redhat.com>
Cc:     linux-cachefs@redhat.com, ceph-devel@vger.kernel.org,
        linux-afs@lists.infradead.org,
        Anna Schumaker <anna.schumaker@netapp.com>,
        linux-nfs@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-mm@kvack.org, Matthew Wilcox <willy@infradead.org>,
        linux-fsdevel@vger.kernel.org,
        Dave Wysochanski <dwysocha@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        v9fs-developer@lists.sourceforge.net, linux-cifs@vger.kernel.org,
        Latchesar Ionkov <lucho@ionkov.net>,
        Jeff Layton <jlayton@kernel.org>,
        Steve French <sfrench@samba.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Trond Myklebust <trondmy@hammerspace.com>,
        Jeff Layton <jlayton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/67] fscache: Rewrite index API and management system
Message-ID: <YXHntB2O0ACr0pbz@relinquished.localdomain>
References: <163456861570.2614702.14754548462706508617.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163456861570.2614702.14754548462706508617.stgit@warthog.procyon.org.uk>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Oct 18, 2021 at 03:50:15PM +0100, David Howells wrote:
> 
> Here's a set of patches that rewrites and simplifies the fscache index API
> to remove the complex operation scheduling and object state machine in
> favour of something much smaller and simpler.  It is built on top of the
> set of patches that removes the old API[1].
> 
> The operation scheduling API was intended to handle sequencing of cache
> operations, which were all required (where possible) to run asynchronously
> in parallel with the operations being done by the network filesystem, while
> allowing the cache to be brought online and offline and interrupt service
> with invalidation.
> 
> However, with the advent of the tmpfile capacity in the VFS, an opportunity
> arises to do invalidation much more easily, without having to wait for I/O
> that's actually in progress: Cachefiles can simply cut over its file
> pointer for the backing object attached to a cookie and abandon the
> in-progress I/O, dismissing it upon completion.
> 
> Future work there would involve using Omar Sandoval's vfs_link() with
> AT_LINK_REPLACE[2] to allow an extant file to be displaced by a new hard
> link from a tmpfile as currently I have to unlink the old file first.

I had forgotten about that. It'd be great to finish that someday, but
given the dead-end of the last discussion [1], we might need to hash it
out the next time we can convene in person.

1:https://lore.kernel.org/linux-fsdevel/364531.1579265357@warthog.procyon.org.uk/ 
