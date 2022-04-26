Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8841150FC48
	for <lists+ceph-devel@lfdr.de>; Tue, 26 Apr 2022 13:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349677AbiDZLzi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 26 Apr 2022 07:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349679AbiDZLze (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 26 Apr 2022 07:55:34 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE5C6B0AA
        for <ceph-devel@vger.kernel.org>; Tue, 26 Apr 2022 04:52:24 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id m20so14797435ejj.10
        for <ceph-devel@vger.kernel.org>; Tue, 26 Apr 2022 04:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a4CT5qc4qsROEKFAPWzIjJhQmUbnKpnAHbEkMWvFs7Y=;
        b=F0M3web/8cVqpT+UxJdMdny3vHeCoBWhTJQQFfR+qMZBV28DvYKsRv/NuYNx7tcz95
         YQkUu7D6p0p3WqJdFS4zDACFDYyFiBG1lJ1TxDC3bOI4isFtj7H+6nr28SgSGmTG+DrW
         7NefuN/VrAqsJsTcu1RLkk19HvXR9+AcRgJRk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a4CT5qc4qsROEKFAPWzIjJhQmUbnKpnAHbEkMWvFs7Y=;
        b=VTUk9Qc3Q9eNE3kAu3/siYzKgC+tLVOfOzIdfgsZrAKYnvJLoR1pPk0WhjjSOUG7Gi
         KK5H/LFEHWjjEyTiuw4lNCIC/xpAW9i/zBHE/wiGMSinAJL0lzyY3wiD56cWiLyVGJRL
         ttO2vkv9Hyeg3V1K6MjpZwCKUO7/YO17RsPY9x6HPZ8c36O/vfB+3+iXdnK904f9Uhwg
         3/o30aZGi+HWXkUD6TsVp9f4/sR02tGG/Q0cFtghBjptt+vHUJuyUKF78dVwYffvYfh6
         /lDye8QhCRa3p+G/U1SSfEbJEOJ272nUvBaeTco0gzpUaOfU3ORDn7X79996GvZ+9G1p
         MjCQ==
X-Gm-Message-State: AOAM531r8h7M6Q8oKjb+493r6O6JgUnL1vTPcaov60+aAsGFVTSdxfkX
        9iCfuGDXb+KK71uAtyV1Poy27qz55Uf61J/h8lVnQA==
X-Google-Smtp-Source: ABdhPJx4G2oTaVlD+Ygbe2r6xvzB2d6cSPr8XzTCobtt8yO9ibtueWpqFv6oHV8Vi1mmIfULUU7VJFOJBX1cwKAoLdw=
X-Received: by 2002:a17:906:2991:b0:6cf:6b24:e92f with SMTP id
 x17-20020a170906299100b006cf6b24e92fmr20763178eje.748.1650973943154; Tue, 26
 Apr 2022 04:52:23 -0700 (PDT)
MIME-Version: 1.0
References: <1650971490-4532-1-git-send-email-xuyang2018.jy@fujitsu.com>
 <1650971490-4532-3-git-send-email-xuyang2018.jy@fujitsu.com>
 <20220426103846.tzz66f2qxcxykws3@wittgenstein> <CAOQ4uxhRMp4tM9nP+0yPHJyzPs6B2vtX6z51tBHWxE6V+UZREw@mail.gmail.com>
In-Reply-To: <CAOQ4uxhRMp4tM9nP+0yPHJyzPs6B2vtX6z51tBHWxE6V+UZREw@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 26 Apr 2022 13:52:11 +0200
Message-ID: <CAJfpegu5uJiHgHmLcuSJ6+cQfOPB2aOBovHr4W5j_LU+reJsCw@mail.gmail.com>
Subject: Re: [PATCH v8 3/4] fs: move S_ISGID stripping into the vfs
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        Yang Xu <xuyang2018.jy@fujitsu.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jeff Layton <jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 26 Apr 2022 at 13:21, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Apr 26, 2022 at 1:38 PM Christian Brauner <brauner@kernel.org> wrote:

> > One thing that I just remembered and which I think I haven't mentioned
> > so far is that moving S_ISGID stripping from filesystem callpaths into
> > the vfs callpaths means that we're hoisting this logic out of vfs_*()
> > helpers implicitly.
> >
> > So filesystems that call vfs_*() helpers directly can't rely on S_ISGID
> > stripping being done in vfs_*() helpers anymore unless they pass the
> > mode on from a prior run through the vfs.
> >
> > This mostly affects overlayfs which calls vfs_*() functions directly. So
> > a typical overlayfs callstack would be (roughly - I'm omw to lunch):
> >
> > sys_mknod()
> > -> do_mknodat(mode) // calls vfs_prepare_mode()
> >    -> .mknod = ovl_mknod(mode)
> >       -> ovl_create(mode)
> >          -> vfs_mknod(mode)
> >
> > I think we are safe as overlayfs passes on the mode on from its own run
> > through the vfs and then via vfs_*() to the underlying filesystem but it
> > is worth point that out.
> >
> > Ccing Amir just for confirmation.
>
> Looks fine to me, but CC Miklos ...

Looks fine to me as well.  Overlayfs should share the mode (including
the suid and sgid bits), owner, group and ACL's with the underlying
filesystem, so clearing sgid based on overlay parent directory should
result in the same mode as if it was done based on the parent
directory on the underlying layer.

AFAIU this logic is not affected by userns or mnt_userns, but
Christian would be best to confirm that.

Thanks,
Miklos
