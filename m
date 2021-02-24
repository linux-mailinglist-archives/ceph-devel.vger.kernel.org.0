Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF7D323AB8
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Feb 2021 11:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234912AbhBXKpr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Feb 2021 05:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234914AbhBXKpb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 24 Feb 2021 05:45:31 -0500
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9075C06174A
        for <ceph-devel@vger.kernel.org>; Wed, 24 Feb 2021 02:44:50 -0800 (PST)
Received: by mail-vk1-xa35.google.com with SMTP id e3so285510vkn.9
        for <ceph-devel@vger.kernel.org>; Wed, 24 Feb 2021 02:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7IeVrluan2r2kYEdEBttnfq/zM9jcQl9nm+rI5Hkr4o=;
        b=av1wcjABNicK94u3ElvqGuVPfJykZiudez3NH0qMVLgXPS7gyUY6TPG5Uu5OEuYCsM
         sJ+9LQeebUu6iRayXoqXLEhXxqLpGm8ar+uwgnNpWp0YFFIi9vPezL7VykoxNJrLW9Zo
         QcwhNWs8X3Gx/1fqCcCv+wtkuRdJHjiuy7qW8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7IeVrluan2r2kYEdEBttnfq/zM9jcQl9nm+rI5Hkr4o=;
        b=LG/Rss5yfXobA38eURQWJgS0ydTNiyHAQ9GNo4Llfh3Jl30O+qBf+XxyKaj2ezMpNI
         n5s8prDgMwnA4ieP03oVya/91waXNnKz8B7JQ+B7LBK9pyg2s/pEid17djh0R7+waAKy
         GLPgd7dCSZo1olwV+xm42b9hKhQEMO6KRGeci63SSrTT8E//BRBMyfgH/UFSfNe7Axod
         EvRncQ15w9eGkI1xezU0kMK4NoLubE4wb99ImHCkfGNIBSK8/pjILP1qknxB+1EYzOoD
         jOxwqHEVCx3uOHLU5bMIy4Xtl9Q0VAYb+XmhGvC0I/nbo17UD52MWRAoKZ5CkXWkEPGy
         u6jA==
X-Gm-Message-State: AOAM532KMlmmwocZcdSa/XSYcW+pvGuiUUPYXjZqhnMw2ztpouvcGUzJ
        tLv2N4ePYIXn8hZZHSlsxZLXleGP1mKtN/qOaSoGvQ==
X-Google-Smtp-Source: ABdhPJwcNF1awAfqI71jc+osdOvaKBSAu3tcjeQYXjwNeU8VD31ZIj0UmTyh4zCeNoXqu9c1BxTl4zi+NBhRQ2wYoTw=
X-Received: by 2002:a1f:ab52:: with SMTP id u79mr19791797vke.9.1614163489899;
 Wed, 24 Feb 2021 02:44:49 -0800 (PST)
MIME-Version: 1.0
References: <20210221195833.23828-1-lhenriques@suse.de> <20210222102456.6692-1-lhenriques@suse.de>
 <CAN-5tyELMY7b7CKO-+an47ydq8r_4+SOyhuvdH0qE0-JmdZ44Q@mail.gmail.com> <YDYpHccgM7agpdTQ@suse.de>
In-Reply-To: <YDYpHccgM7agpdTQ@suse.de>
From:   Nicolas Boichat <drinkcat@chromium.org>
Date:   Wed, 24 Feb 2021 18:44:38 +0800
Message-ID: <CANMq1KBgwEXFh8AxpPW2t1SA0NVsyR45m0paLEU4D4w80dc_fA@mail.gmail.com>
Subject: Re: [PATCH v8] vfs: fix copy_file_range regression in cross-fs copies
To:     Luis Henriques <lhenriques@suse.de>
Cc:     Olga Kornievskaia <aglo@umich.edu>,
        Amir Goldstein <amir73il@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Steve French <sfrench@samba.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Ian Lance Taylor <iant@google.com>,
        Luis Lozano <llozano@chromium.org>,
        Andreas Dilger <adilger@dilger.ca>,
        Christoph Hellwig <hch@infradead.org>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-nfs <linux-nfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Feb 24, 2021 at 6:22 PM Luis Henriques <lhenriques@suse.de> wrote:
>
> On Tue, Feb 23, 2021 at 08:00:54PM -0500, Olga Kornievskaia wrote:
> > On Mon, Feb 22, 2021 at 5:25 AM Luis Henriques <lhenriques@suse.de> wro=
te:
> > >
> > > A regression has been reported by Nicolas Boichat, found while using =
the
> > > copy_file_range syscall to copy a tracefs file.  Before commit
> > > 5dae222a5ff0 ("vfs: allow copy_file_range to copy across devices") th=
e
> > > kernel would return -EXDEV to userspace when trying to copy a file ac=
ross
> > > different filesystems.  After this commit, the syscall doesn't fail a=
nymore
> > > and instead returns zero (zero bytes copied), as this file's content =
is
> > > generated on-the-fly and thus reports a size of zero.
> > >
> > > This patch restores some cross-filesystem copy restrictions that exis=
ted
> > > prior to commit 5dae222a5ff0 ("vfs: allow copy_file_range to copy acr=
oss
> > > devices").  Filesystems are still allowed to fall-back to the VFS
> > > generic_copy_file_range() implementation, but that has now to be done
> > > explicitly.
> > >
> > > nfsd is also modified to fall-back into generic_copy_file_range() in =
case
> > > vfs_copy_file_range() fails with -EOPNOTSUPP or -EXDEV.
> > >
> > > Fixes: 5dae222a5ff0 ("vfs: allow copy_file_range to copy across devic=
es")
> > > Link: https://lore.kernel.org/linux-fsdevel/20210212044405.4120619-1-=
drinkcat@chromium.org/
> > > Link: https://lore.kernel.org/linux-fsdevel/CANMq1KDZuxir2LM5jOTm0xx+=
BnvW=3DZmpsG47CyHFJwnw7zSX6Q@mail.gmail.com/
> > > Link: https://lore.kernel.org/linux-fsdevel/20210126135012.1.If45b7cd=
c3ff707bc1efa17f5366057d60603c45f@changeid/
> > > Reported-by: Nicolas Boichat <drinkcat@chromium.org>
> > > Signed-off-by: Luis Henriques <lhenriques@suse.de>
> >
> > I tested v8 and I believe it works for NFS.
>
> Thanks a lot for the testing.  And to everyone else for reviews,
> feedback,... and patience.

Thanks so much to you!!!

Works here, you can add my
Tested-by: Nicolas Boichat <drinkcat@chromium.org>

>
> I'll now go look into the manpage and see what needs to be changed.
>
> Cheers,
> --
> Lu=C3=ADs
