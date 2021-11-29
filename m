Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4631F462617
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Nov 2021 23:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbhK2WrA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Nov 2021 17:47:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234891AbhK2Wo3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 29 Nov 2021 17:44:29 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB8DC03AD69
        for <ceph-devel@vger.kernel.org>; Mon, 29 Nov 2021 10:13:13 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id y13so75555901edd.13
        for <ceph-devel@vger.kernel.org>; Mon, 29 Nov 2021 10:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A1KpMLhPpZ3DtBAJ2H7WA1+eK6RBPvYL8JCpapFonpw=;
        b=hYrTDwhmtIHMqqbXGO1Kse+Z0mztn57tvq1yPxTQ6q8If5SiUN3r2mIlQQuhqQ5Ciu
         K5ZjiwPNhDNHwoG8b/skXzWnqGGnw5Xo6Kz7rDlvP/WRSBwiwJnbIMXZ+5EJLE2YnPsh
         8oCcdh7mNJuIoeX8m73ktIFQqXot2Q8wW5BQM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A1KpMLhPpZ3DtBAJ2H7WA1+eK6RBPvYL8JCpapFonpw=;
        b=oZm3jrgsdugIqzg5zeIgf41zJxvtk9hP9ygo2xdWajNdyj6RdTzL63D4JQaBkytK1/
         2WE0tVGL2ZB+hwC9tmPsuREYCbMiktkIdfnefSJxAC1vPXAK7saRw289XNI24iEMnEuN
         4bi5bJE/h2R4+BYghNk+7OrejyfT9EmVpBoW25Kc1zvJ5/Pno3Get1MqjtOBCiKaL4Oy
         8iuM8cBaFr+MYesrirEdC/Y0qhp8cpYd2ATL6aRFueYapoe8aZgHCecAc/tSjxdZSclj
         4LQwJGkRGyu8IIwSD5askQRICzUDOle4EhClF/n1U49d6ftt3+WhCaxnKgowK2vI0Bp0
         8/Qg==
X-Gm-Message-State: AOAM532bhqaeGsvcFM+tP6vrq2lLKKFYfgQzNjRa/dzMRofVsg2OUQih
        Nh5hGzb63uBNwyC9TLpdWNGRXE/U+gocRoQnVAc=
X-Google-Smtp-Source: ABdhPJyygeF5O/yHVW9jvfejhPRRaIE86e5Gd0wkhElG+j1AKf8psj7ayok8uPe/jA6x9W1v8dF1ig==
X-Received: by 2002:a17:906:2bd5:: with SMTP id n21mr62295828ejg.337.1638209592217;
        Mon, 29 Nov 2021 10:13:12 -0800 (PST)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id w7sm9574668ede.66.2021.11.29.10.13.12
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 10:13:12 -0800 (PST)
Received: by mail-ed1-f44.google.com with SMTP id r11so75758855edd.9
        for <ceph-devel@vger.kernel.org>; Mon, 29 Nov 2021 10:13:12 -0800 (PST)
X-Received: by 2002:adf:9d88:: with SMTP id p8mr36748101wre.140.1638209581186;
 Mon, 29 Nov 2021 10:13:01 -0800 (PST)
MIME-Version: 1.0
References: <163819575444.215744.318477214576928110.stgit@warthog.procyon.org.uk>
In-Reply-To: <163819575444.215744.318477214576928110.stgit@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 29 Nov 2021 10:12:45 -0800
X-Gmail-Original-Message-ID: <CAHk-=whGOEEb4n2_y3mnrmeNx4HYjRA-m=xMPDQD=bHWfB5chw@mail.gmail.com>
Message-ID: <CAHk-=whGOEEb4n2_y3mnrmeNx4HYjRA-m=xMPDQD=bHWfB5chw@mail.gmail.com>
Subject: Re: [PATCH 00/64] fscache, cachefiles: Rewrite
To:     David Howells <dhowells@redhat.com>
Cc:     linux-cachefs@redhat.com, Jeff Layton <jlayton@kernel.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        linux-afs@lists.infradead.org, Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Dave Wysochanski <dwysocha@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Marc Dionne <marc.dionne@auristor.com>,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        v9fs-developer@lists.sourceforge.net,
        Trond Myklebust <trondmy@hammerspace.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Omar Sandoval <osandov@osandov.com>,
        ceph-devel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Nov 29, 2021 at 6:22 AM David Howells <dhowells@redhat.com> wrote:
>
> The patchset is structured such that the first few patches disable fscache
> use by the network filesystems using it, remove the cachefiles driver
> entirely and as much of the fscache driver as can be got away with without
> causing build failures in the network filesystems.  The patches after that
> recreate fscache and then cachefiles, attempting to add the pieces in a
> logical order.  Finally, the filesystems are reenabled and then the very
> last patch changes the documentation.

Thanks, this all looks conceptually sane to me.

But I only really scanned the commit messages, not the actual new
code. That obviously needs all the usual testing and feedback from the
users of this all..

                    Linus
