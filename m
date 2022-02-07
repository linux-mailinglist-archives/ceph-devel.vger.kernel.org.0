Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38ED24AC619
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Feb 2022 17:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbiBGQj7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Feb 2022 11:39:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239398AbiBGQ2S (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 7 Feb 2022 11:28:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3D996C0401DA
        for <ceph-devel@vger.kernel.org>; Mon,  7 Feb 2022 08:28:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644251297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8UdlxFSo9O6GJ/VsjDu4ZJkiX3dKPMLesoeYXprjHKg=;
        b=BWfdqsYFkOcVHtj9YLNdZdSHLWbHv/z/GTdUXeGBoVUv30Dvhq87GX9JapDIVMjAu7Rg9f
        QNZcBncRE3FqjO2UOrHp1CcW/ij5NPe/vFJobVyAZ3uFexF22KDV1qv8OqBZZbgmvP9P+n
        C0T6nXdAMnA43ad05Gv3SHzQFpHKe74=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-nUEfpAlWNq2t5D8Ni7C-fw-1; Mon, 07 Feb 2022 11:28:16 -0500
X-MC-Unique: nUEfpAlWNq2t5D8Ni7C-fw-1
Received: by mail-qv1-f72.google.com with SMTP id 14-20020a05621420ee00b00423846005d4so8973918qvk.15
        for <ceph-devel@vger.kernel.org>; Mon, 07 Feb 2022 08:28:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8UdlxFSo9O6GJ/VsjDu4ZJkiX3dKPMLesoeYXprjHKg=;
        b=RqOWwh09/WtiWFG0m9r3enEezACxOwnEdtt7+5cQsOmJpG5sPB0OH+UYiejltJjY86
         Q52AKUb/nJSui23MPGTGxajFt6uwdyvBpg5lgzODqZMVwWiGSKZbCIqcx+CdIazx7yiY
         nNph4tiVEjqvIk1XDnA7Ef7fYB3ihQme4+qMU173orP2oCSa8+rTyAuqxSvbh+RPNKqY
         HzIIgGLcn6PnCZSwx+gCARzCPWhgcSqQN3Z6XtmBXwtsJZXRLLd+MrMoxkXLILcj7wXk
         r2DpohVthx9qFbSMa3B5fhVWEMcGLZCP7LrdGS+GUfMH3lXFCx3NEBrlcCqxcKSxXaHn
         PBLA==
X-Gm-Message-State: AOAM532YeyYuAluw6VVn8myQoBa73z4S0bojjb2zwQ9389jMUIXczJBp
        zTbkkzqs7xJ7yeCSK+eXIA00BqQCOwihec8zp4eJMkno37fpb9/EO93Zp6yuUTatBnakrjcyWB0
        AS9psBD1w2MPkM942Lkr7wujQclp9K+FA6qeEsA==
X-Received: by 2002:a37:afc2:: with SMTP id y185mr331300qke.681.1644251295592;
        Mon, 07 Feb 2022 08:28:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzQE8qW49tVDYpFz2A1SjfzY92EhispBndvF6cRtUZWD2Gt66h4VPxWOZnBE2QVe7Ql28ch9KqHb5nAFnHODzM=
X-Received: by 2002:a37:afc2:: with SMTP id y185mr331284qke.681.1644251295251;
 Mon, 07 Feb 2022 08:28:15 -0800 (PST)
MIME-Version: 1.0
References: <20220207050340.872893-1-xiubli@redhat.com> <77bd8ec8fb97107deb57c641b5e471b8eeb828c8.camel@kernel.org>
 <CAJ4mKGbHyn-oQwL8D3Ove0d2tD++VEXOTMSj5EDbcBk3SFX=2w@mail.gmail.com> <d6f16704da303eca4d62aee58eecacb45f76f45a.camel@kernel.org>
In-Reply-To: <d6f16704da303eca4d62aee58eecacb45f76f45a.camel@kernel.org>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Mon, 7 Feb 2022 08:28:03 -0800
Message-ID: <CAJ4mKGb3j_QNMuKmccoj43jswoReb_iP8wnJi3f-mpaN++PC7w@mail.gmail.com>
Subject: Re: [PATCH] ceph: fail the request directly if handle_reply gets an ESTALE
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Dan van der Ster <dan@vanderster.com>,
        Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Sage Weil <sage@newdream.net>, ukernel <ukernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Feb 7, 2022 at 8:13 AM Jeff Layton <jlayton@kernel.org> wrote:
> The tracker bug mentions that this occurs after an MDS is restarted.
> Could this be the result of clients relying on delete-on-last-close
> behavior?

Oooh, I didn't actually look at the tracker.

>
> IOW, we have a situation where a file is opened and then unlinked, and
> userland is actively doing I/O to it. The thing gets moved into the
> strays dir, but isn't unlinked yet because we have open files against
> it. Everything works fine at this point...
>
> Then, the MDS restarts and the inode gets purged altogether. Client
> reconnects and tries to reclaim his open, and gets ESTALE.

Uh, okay. So I didn't do a proper audit before I sent my previous
reply, but one of the cases I did see was that the MDS returns ESTALE
if you try to do a name lookup on an inode in the stray directory. I
don't know if that's what is happening here or not? But perhaps that's
the root of the problem in this case.

Oh, nope, I see it's issuing getattr requests. That doesn't do ESTALE
directly so it must indeed be coming out of MDCache::path_traverse.

The MDS shouldn't move an inode into the purge queue on restart unless
there were no clients with caps on it (that state is persisted to disk
so it knows). Maybe if the clients don't make the reconnect window
it's dropping them all and *then* moves it into purge queue? I think
we need to identify what's happening there before we issue kernel
client changes, Xiubo?
-Greg

