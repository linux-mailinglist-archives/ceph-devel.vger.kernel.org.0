Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEEF3042CA
	for <lists+ceph-devel@lfdr.de>; Tue, 26 Jan 2021 16:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391777AbhAZPmU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 26 Jan 2021 10:42:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29787 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391310AbhAZPgF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 26 Jan 2021 10:36:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611675278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+sg4yNwZrAUtqGjsjAIZF/lC9W6Hi56SguvTv3qRusA=;
        b=AvAimHzoNnyt6HHce6CcX+chG4tX7GRBMoCQqfIxXhqI8JNTZLdVRQ5eCsiWDp3LoQW+Ll
        BeRU+iGXcpfeyr40dWf/CDbUTRRooyC2d0rayKu4vV7JNCkHFFE87e7d5qPvPql+tPM8IL
        LMZSLZtAFSNufeHw3Gm8odSA9k8MABg=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-vdF978hINlGDTvBXYiXRxg-1; Tue, 26 Jan 2021 10:34:36 -0500
X-MC-Unique: vdF978hINlGDTvBXYiXRxg-1
Received: by mail-ed1-f70.google.com with SMTP id a26so9622794edx.8
        for <ceph-devel@vger.kernel.org>; Tue, 26 Jan 2021 07:34:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+sg4yNwZrAUtqGjsjAIZF/lC9W6Hi56SguvTv3qRusA=;
        b=LAjrUoiNlhjEf0jH28jgBEBMEo1cyI6iazWL96vcB+4JPgH/PFu4WrMJbUJp3EfLmR
         0Whrj/KNG8Sfh7hFplYzDt/EavHp3jvYTiD4OX2TPMRdhBkMEMLHTOBNaRhGAv9JZdVr
         nZH6IOmMqlOsu6ktO0rRvjn1OqDNB4mV5eFf0tRzXuFkW+LtznEqrSVBmvvFWYVxASFO
         7MCQwLlOaK0OdEBcTp5qesK00AoE0D54Bhxne3D7i5PmRXJgAjM+145ZAynCL857NMyy
         h/ko1u7wgl5AWdCmKxZgxeWXeqoR/1wvHu/LhiJKtm8HicezNI+ooOXWhQV9Fzz7zVQP
         R4xA==
X-Gm-Message-State: AOAM531+XDuqMWQiNVd9+ZAwAh4sqYOpXt3X6LpnR4V8lgW1fJ3CoXDz
        EBEdTL384yHQRw3Pr+urMSa7GGglwfPDE135rOyl2xIxrj2bISP+LL6hwiiKW+w+hYiunbNOW4Y
        QgSVHFjD0CA/c1/15fF1c54NoAytMKEQ68NOWJA==
X-Received: by 2002:a17:906:4451:: with SMTP id i17mr2289512ejp.436.1611675275261;
        Tue, 26 Jan 2021 07:34:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzSasZks4PL3NUJQfxg7We8UW4x28G54NbjOgDuCVAFpi7QKXrub9Pz5L3G6Ovg3Un+JLmrv6pQRbddbpD7RMI=
X-Received: by 2002:a17:906:4451:: with SMTP id i17mr2289493ejp.436.1611675275099;
 Tue, 26 Jan 2021 07:34:35 -0800 (PST)
MIME-Version: 1.0
References: <161161025063.2537118.2009249444682241405.stgit@warthog.procyon.org.uk>
 <161161054970.2537118.5401048451896267742.stgit@warthog.procyon.org.uk> <20210126035928.GJ308988@casper.infradead.org>
In-Reply-To: <20210126035928.GJ308988@casper.infradead.org>
From:   David Wysochanski <dwysocha@redhat.com>
Date:   Tue, 26 Jan 2021 10:33:59 -0500
Message-ID: <CALF+zOkNMHjtH+cZrGQFqbH5dD5gUpV+y3k-Bt31E35d4kn1oA@mail.gmail.com>
Subject: Re: [PATCH 25/32] NFS: Clean up nfs_readpage() and nfs_readpages()
To:     Matthew Wilcox <willy@infradead.org>
Cc:     David Howells <dhowells@redhat.com>,
        Trond Myklebust <trondmy@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Jeff Layton <jlayton@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-cachefs@redhat.com, linux-afs@lists.infradead.org,
        linux-nfs <linux-nfs@vger.kernel.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        ceph-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jan 25, 2021 at 11:01 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Mon, Jan 25, 2021 at 09:35:49PM +0000, David Howells wrote:
> > -int nfs_readpage(struct file *file, struct page *page)
> > +int nfs_readpage(struct file *filp, struct page *page)
>
> I appreciate we're inconsistent between file and filp, but we're actually
> moving more towards file than filp.
>
Got it, easy enough to change.

