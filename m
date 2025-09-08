Return-Path: <ceph-devel+bounces-3557-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4799AB48A46
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Sep 2025 12:36:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7159C3C064B
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Sep 2025 10:35:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63B902FA0ED;
	Mon,  8 Sep 2025 10:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZN6pjTBE"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2492F99A3;
	Mon,  8 Sep 2025 10:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757327715; cv=none; b=nPoT29QMRQj6y+H/beRsngjUbSTR/oP5CHCfyh/B/48+uSWjq3Sodj1Y4RkuYEnQAFxOZrg2y4DE5FXgm9BwtdsyBUPsoRnPRYsia4MNTWVMjTBdkxlu8tq+WMWSXwHPEuKWu5B7/WeyHvC7qo0svwvnv2N3l/U/15IXK1/sN1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757327715; c=relaxed/simple;
	bh=BmVD7QgfOTrfaLNX9a19UJnOQJln7DMGiCLlEQdlL9w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iKUnvzNj6t5NMhf5fsIy7q6Kxq/GUfGG8RkHNyZ/JFiUnWuxBQdrrTTTSSWeRfa76szfjit6YGaDIO8IlbqXvATo7ObD6Jc6SOsBWXE4PYOkyFE6jv3AIy5GbLB4fJQCopZd9+Y2pgHJ4FP1FPmeLjKpXpRyKFgc4t05o8IIdZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZN6pjTBE; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b4c6fee41c9so3246713a12.1;
        Mon, 08 Sep 2025 03:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757327713; x=1757932513; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cxTumnJifkgJPif7PVPxOq7jYsk5ivTAe0dBYkW3OnI=;
        b=ZN6pjTBE4t+jnmO7FF3D7fQdcGALqhBMWMfGOCXoCZC4gPQxqUhLh0j4n9aCn1LoIv
         cTbJYkZdU+04PUWBbLNgWUzVEtMDwACg8bzVzZiaLn7cQWMOylaVusDliDK9m97OPJ7B
         Nvf/XM13Ksma96KBOQHJrkEMvWholtJB/c78WCzvDvw8bXwFWG+PSkZFOco4vZMBTwdI
         MsZzp1+C21NBVJFLJ3Ao0HChgSsGj172Sqh1WgDzZGN6KDnjQ3WEyX5ekZpKB1cUKdy5
         ppnv01g4nsCZdv4l46Rn7c+vVyiLoLarvwoxjpAkZKwj7/o8LPY7TCfoWlORLE9U695L
         ilpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757327713; x=1757932513;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cxTumnJifkgJPif7PVPxOq7jYsk5ivTAe0dBYkW3OnI=;
        b=nO2MFfj93mAzym/MtW0nufuLbANYcInpOx/2fMau5y60j6wrRwJ8Id0oXK5pxNeiCS
         0cw8hV7FXpT0pQKhsa6xpYV1JHIf4423hY+v4q3RrkHaNorHjGgregc2+6GSD+B3yDvx
         mS6/NUf9l9WrAjul0QIdErLTWdrmNiBaGF1XRpVCoLSpLXl649C4Qwnr8QnJ7RjbUpAZ
         /pIXUx9t53namFj0QiS+MqWPmyyPBwc6ZToXicURDiouE04c5P2jD9yO07b2HUc6/Z2Y
         SDub1LfupN+WcOEukW/5IKtkW3mmQ6u+1AQ4M6OYFiyhObmy6yY2bUYO01Y+sIWsuMEq
         Sc3A==
X-Forwarded-Encrypted: i=1; AJvYcCUhVVIKbY1Vi2rOCbmw5nhRlJPaGEZkV8qzCKnPuMrfjjxcoDs1nsA1DWgFsa9nMa/FnTqzkaD+vtaL@vger.kernel.org, AJvYcCUsn3LPR7vDqSWVLTdIxQ2IlY/rKwLZcW0/rt5CdQeo9ScKEfOAxExiSOpanJVhzs5qPVtBw5E0@vger.kernel.org, AJvYcCV/JTV4do8kuyB05YWbEVNp9qV8D9WFFfgwakqPzekZz1XTohT0TXKIaWBO1ChCzaWPUCFkcTzSROHsCN7H@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9e3r/8d8hPd9m/YBWN0N8bE2sGgnMFJvldTscnnZ55HNebXEh
	IXjmhPczN/DZsE8BgyqvRdhVsN7BlTneJPZLNq0ZtTbk6/r4Fx3tEkGlK7y85NStg4kHeqFolWr
	307r8kXAvmwRyirBvD7BRwPqh7REewdmCh1Qf
X-Gm-Gg: ASbGncvSgQrRLSu4L2Qs51jii6yqhLii7zLNglotMn6gqNjlhO5FYtVa3z/SjNy0yLs
	s5thyFgaQy0U81pqN0M9C+CLEE9LQR+B/VhroHfUKUbcKzmDXR2UwxAkXhVTRElGzhAp2Y6zT03
	NmPWvN0mZDO6uJsV+rWGPTdbfLYUYjtb5lqp1eoXwYDoQvkcDVHmEbrnPcqlJoIjcDC6xnEq495
	ioz5fU=
X-Google-Smtp-Source: AGHT+IHXwJt48TDntK7/dCdj92RM0HKdEkW0OokMFMRElaK12ng3FfBDWu6bqf5x/X3vMFfaoOizFjTHychWtuxyZCY=
X-Received: by 2002:a17:903:2450:b0:246:a543:199 with SMTP id
 d9443c01a7336-25173301e63mr112072155ad.54.1757327712942; Mon, 08 Sep 2025
 03:35:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250828111552.686973-1-max.kellermann@ionos.com>
In-Reply-To: <20250828111552.686973-1-max.kellermann@ionos.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 8 Sep 2025 12:35:01 +0200
X-Gm-Features: Ac12FXwNJ0Ml2g9M4GdnARoDd-tEu5GevYJx9y9IgKfVsaczWvQRN8fh3JOEpSA
Message-ID: <CAOi1vP-p9GbzMHNRUa+vyC16w1zaFkfkZY7KX83217=o1qNg_g@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/addr: fix crash after fscrypt_encrypt_pagecache_blocks()
 error
To: Max Kellermann <max.kellermann@ionos.com>
Cc: Slava.Dubeyko@ibm.com, xiubli@redhat.com, amarkuze@redhat.com, 
	ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org, brauner@kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 28, 2025 at 1:16=E2=80=AFPM Max Kellermann <max.kellermann@iono=
s.com> wrote:
>
> The function move_dirty_folio_in_page_array() was created by commit
> ce80b76dd327 ("ceph: introduce ceph_process_folio_batch() method") by
> moving code from ceph_writepages_start() to this function.
>
> This new function is supposed to return an error code which is checked
> by the caller (now ceph_process_folio_batch()), and on error, the
> caller invokes redirty_page_for_writepage() and then breaks from the
> loop.
>
> However, the refactoring commit has gone wrong, and it by accident, it
> always returns 0 (=3D success) because it first NULLs the pointer and
> then returns PTR_ERR(NULL) which is always 0.  This means errors are
> silently ignored, leaving NULL entries in the page array, which may
> later crash the kernel.
>
> The simple solution is to call PTR_ERR() before clearing the pointer.
>
> Fixes: ce80b76dd327 ("ceph: introduce ceph_process_folio_batch() method")
> Link: https://lore.kernel.org/ceph-devel/aK4v548CId5GIKG1@swift.blarg.de/
> Cc: stable@vger.kernel.org
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---
>  fs/ceph/addr.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 8b202d789e93..e3e0d477f3f7 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -1264,7 +1264,9 @@ static inline int move_dirty_folio_in_page_array(st=
ruct address_space *mapping,
>                                                                 0,
>                                                                 gfp_flags=
);
>                 if (IS_ERR(pages[index])) {
> -                       if (PTR_ERR(pages[index]) =3D=3D -EINVAL) {
> +                       int err =3D PTR_ERR(pages[index]);
> +
> +                       if (err =3D=3D -EINVAL) {
>                                 pr_err_client(cl, "inode->i_blkbits=3D%hh=
u\n",
>                                                 inode->i_blkbits);
>                         }
> @@ -1273,7 +1275,7 @@ static inline int move_dirty_folio_in_page_array(st=
ruct address_space *mapping,
>                         BUG_ON(ceph_wbc->locked_pages =3D=3D 0);
>
>                         pages[index] =3D NULL;
> -                       return PTR_ERR(pages[index]);
> +                       return err;
>                 }
>         } else {
>                 pages[index] =3D &folio->page;
> --
> 2.47.2
>

Queued up for 6.17-rc6.

Thanks,

                Ilya

