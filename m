Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92EDBA522F
	for <lists+ceph-devel@lfdr.de>; Mon,  2 Sep 2019 10:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730778AbfIBIvU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 2 Sep 2019 04:51:20 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:42569 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729408AbfIBIvU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 2 Sep 2019 04:51:20 -0400
Received: by mail-io1-f65.google.com with SMTP id n197so25721648iod.9;
        Mon, 02 Sep 2019 01:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TFd0u6ewLXlhCLWpF9FFudlGz6TeEZMvoBbbckwaiaA=;
        b=vgvgh6S+7r8eWIlqtoP4drYrOQhbKpR3JFN15DhGZvdAS/c+ae+l0eH4+1jQyisxpo
         BRBBoez9cfwO2xiv0pB86YVS1uucLWrKVYSEQuJAJwaL15ymRB+/z7n70frKBMqEC8bU
         1S3POKWc2Z64PqeAON97zAfhZb4UCcf2/KTiRsa0MVBbviZO1IOiM4/VFJh1jVxGWD/5
         vDVOvLXp7oIYa2Rsd+LG8rrwEE90uKsl0MR3fgswfi9y7S4eFO8QdeNBuPGve1DdtBcq
         IaplAtbzaPJQeVW/mWHMB0BWeTJ0ZXG86W6AIEz0MUTL8tiTT3nsrN6uaXyf4ze+y5Df
         HWNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TFd0u6ewLXlhCLWpF9FFudlGz6TeEZMvoBbbckwaiaA=;
        b=qXvwufe5iNg5mqMMIZJpbukSF2NdwurF4hdecTggaUP3Zq2RlN32V6tb/azRffvkS+
         fLN2P3JpaZCC+hxYgAs0hwN7Q6Q4Uiui8OGop/XbNO/fmYiqR+w9RSriMh9IWwZUiZoV
         B9Ym+jy6vd2Rj1c6kNNJsZKgA4RbqtyM3yQkHAPSwK5hWl+oz6punyPihVI3zJion/sd
         LU2mRbsLo8sqKj4vlS0nR2rZEomARniv0sEIBR9ManPesIWJZdbQYk1NFyB2QLJeGqRN
         gQT9+ST4kisy4cWHDj46XMiF4PZyovV6YUW4EcYcRpU6hz0Z/6WLpBhrIhkgTmJ7C1di
         g+ZQ==
X-Gm-Message-State: APjAAAXCkU/t9FhsXFxSfBh03sQLb5KxZQ6tAjbSg8Z0/Ol+Bix7EpT+
        CTi5nbRfgUMc71WDIM/LEOa1EEIvGiabap46I84=
X-Google-Smtp-Source: APXvYqyHimcleYWo0hsVGAlktLF88Ql2jhJbwRXmUofI1cKaxMRWn2maqHXJDAvCrHny4Hp70KgbykwYpiriaKb1y8Y=
X-Received: by 2002:a02:b882:: with SMTP id p2mr5931866jam.16.1567414279790;
 Mon, 02 Sep 2019 01:51:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190831215712.10148-1-kw@linux.com>
In-Reply-To: <20190831215712.10148-1-kw@linux.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 2 Sep 2019 10:54:26 +0200
Message-ID: <CAOi1vP92Q==y7eta5oyhV4q1qjzsMqposGeWbY8rFCWFSpU9yg@mail.gmail.com>
Subject: Re: [PATCH] ceph: Move static keyword to the front of declarations
To:     Krzysztof Wilczynski <kw@linux.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, Aug 31, 2019 at 11:57 PM Krzysztof Wilczynski <kw@linux.com> wrote:
>
> Move the static keyword to the front of declarations of
> snap_handle_length, handle_length and connected_handle_length,
> and resolve the following compiler warnings that can be seen
> when building with warnings enabled (W=3D1):
>
> fs/ceph/export.c:38:2: warning:
>   =E2=80=98static=E2=80=99 is not at beginning of declaration [-Wold-styl=
e-declaration]
>
> fs/ceph/export.c:88:2: warning:
>   =E2=80=98static=E2=80=99 is not at beginning of declaration [-Wold-styl=
e-declaration]
>
> fs/ceph/export.c:90:2: warning:
>   =E2=80=98static=E2=80=99 is not at beginning of declaration [-Wold-styl=
e-declaration]
>
> Signed-off-by: Krzysztof Wilczynski <kw@linux.com>
> ---
> Related: https://lore.kernel.org/r/20190827233017.GK9987@google.com
>
>  fs/ceph/export.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> index 020d39a85ecc..b6bfa94332c3 100644
> --- a/fs/ceph/export.c
> +++ b/fs/ceph/export.c
> @@ -35,7 +35,7 @@ struct ceph_nfs_snapfh {
>  static int ceph_encode_snapfh(struct inode *inode, u32 *rawfh, int *max_=
len,
>                               struct inode *parent_inode)
>  {
> -       const static int snap_handle_length =3D
> +       static const int snap_handle_length =3D
>                 sizeof(struct ceph_nfs_snapfh) >> 2;
>         struct ceph_nfs_snapfh *sfh =3D (void *)rawfh;
>         u64 snapid =3D ceph_snap(inode);
> @@ -85,9 +85,9 @@ static int ceph_encode_snapfh(struct inode *inode, u32 =
*rawfh, int *max_len,
>  static int ceph_encode_fh(struct inode *inode, u32 *rawfh, int *max_len,
>                           struct inode *parent_inode)
>  {
> -       const static int handle_length =3D
> +       static const int handle_length =3D
>                 sizeof(struct ceph_nfs_fh) >> 2;
> -       const static int connected_handle_length =3D
> +       static const int connected_handle_length =3D
>                 sizeof(struct ceph_nfs_confh) >> 2;
>         int type;

Applied.

Thanks,

                Ilya
