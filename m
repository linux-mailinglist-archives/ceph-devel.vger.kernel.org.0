Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 948164778F8
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Dec 2021 17:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233891AbhLPQ2L (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 16 Dec 2021 11:28:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233860AbhLPQ2K (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 16 Dec 2021 11:28:10 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E02C061574
        for <ceph-devel@vger.kernel.org>; Thu, 16 Dec 2021 08:28:10 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id o20so89343320eds.10
        for <ceph-devel@vger.kernel.org>; Thu, 16 Dec 2021 08:28:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fkh9SA21WJAwLXrex3D5hDMvc6XDF8J0dz4irJ+Ae9Y=;
        b=TZ91WtmX33bYGxQ28DYuwMlA4L/Ykfses9BBTD3iJ52Q9qh/2tU+S4awSqTTbNIEfO
         NIVIGXtvrTssU7E/Ib+EszfgqaQI3Ug/c2E/ITq3PkTvuJKpkp8KHKAP+FyMLrxxfyHm
         7LDKJiXUmfROJo2atlx1zLIBfA58BXXUjM6Yc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fkh9SA21WJAwLXrex3D5hDMvc6XDF8J0dz4irJ+Ae9Y=;
        b=ziK8b/A+lZUcHGTbuw2Jb8ksUW1NnMzSq72pNQgfIueN2VkUYl0KbK/uMt5kOp9Dwq
         ww5utNajUuSRAimZzhElwHffhEacroeJqyf2DQOn4KjNdgwZXt0BxKAl15az0in2Y1f1
         gcZzWmZRsDqM15BYSuZXtV3JoteZkSHlL44+x+tWySTNW0LxntkVt95l9XG6nA8jAV1+
         nzY05zfCsJgQRzkmiumB58m/f6hRuMrnVVEuJKwVydYnaZaZ7KODthfrTBQXSQ2n1L3B
         EUbYT/sUP4+u8dawCfsilXv3+nP4dmXRrzFKQpi0WT8OLmOP/h3RSi/fGwbu5/nDe4TH
         H6lg==
X-Gm-Message-State: AOAM532lfc2beswzEQe7a2ZUHczeK24hncdpy5ycdc7NXMh+LYS3czEx
        Dvjw5aKkH5bXABLfyMU8vbcwH8Gx1lb90x4y
X-Google-Smtp-Source: ABdhPJynYw6OqzppcESErQMK2SYNM7uliXKv2ruHMdxtWVr48F1v/mB6U1ONM81Xhy1kFdMpPD2bXg==
X-Received: by 2002:a17:906:458:: with SMTP id e24mr6396010eja.108.1639672088356;
        Thu, 16 Dec 2021 08:28:08 -0800 (PST)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com. [209.85.221.42])
        by smtp.gmail.com with ESMTPSA id w7sm2595911ede.66.2021.12.16.08.28.06
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Dec 2021 08:28:06 -0800 (PST)
Received: by mail-wr1-f42.google.com with SMTP id o13so45111645wrs.12
        for <ceph-devel@vger.kernel.org>; Thu, 16 Dec 2021 08:28:06 -0800 (PST)
X-Received: by 2002:a5d:6211:: with SMTP id y17mr9727999wru.97.1639672086343;
 Thu, 16 Dec 2021 08:28:06 -0800 (PST)
MIME-Version: 1.0
References: <163967073889.1823006.12237147297060239168.stgit@warthog.procyon.org.uk>
 <163967172373.1823006.6118195970180365070.stgit@warthog.procyon.org.uk>
In-Reply-To: <163967172373.1823006.6118195970180365070.stgit@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 16 Dec 2021 08:27:50 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjiba2VRKKjOYAiCZn1Tk9H1tiXcOvjekdo3wPHHmedyQ@mail.gmail.com>
Message-ID: <CAHk-=wjiba2VRKKjOYAiCZn1Tk9H1tiXcOvjekdo3wPHHmedyQ@mail.gmail.com>
Subject: Re: [PATCH v3 57/68] afs: Fix afs_write_end() to handle len > page size
To:     David Howells <dhowells@redhat.com>
Cc:     linux-cachefs@redhat.com, Jeff Layton <jlayton@kernel.org>,
        Marc Dionne <marc.dionne@auristor.com>,
        Matthew Wilcox <willy@infradead.org>,
        linux-afs@lists.infradead.org,
        Trond Myklebust <trondmy@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Omar Sandoval <osandov@osandov.com>,
        JeffleXu <jefflexu@linux.alibaba.com>,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, ceph-devel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Dec 16, 2021 at 8:22 AM David Howells <dhowells@redhat.com> wrote:
>
> It is possible for the len argument to afs_write_end() to overrun the end
> of the page (len is used to key the size of the page in afs_write_start()
> when compound pages become a regular thing).

This smells like a bug in the caller.

It's just insane to call "write_end()" with a range that doesn't
actually fit in the page provided.

Exactly how does that happen, and why should AFS deal with it, not
whoever called write_end()?

              Linus
