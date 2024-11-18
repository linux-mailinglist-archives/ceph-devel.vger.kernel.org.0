Return-Path: <ceph-devel+bounces-2162-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DDD939D154D
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Nov 2024 17:26:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8487B1F22ED0
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Nov 2024 16:26:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADA0D1BD007;
	Mon, 18 Nov 2024 16:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eqsbucZZ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D7019DF5F;
	Mon, 18 Nov 2024 16:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731947169; cv=none; b=CrQbGI+fGnaGXk6PsTxI9Q7+sa8hTfDKzUKeUTl2ohr3ehMxohTDNRrI6fkK8eCJgxg7Bg5xDEuNAUzavGzvK0VjiKjEHl7UfRJ7jYAj7ywCQCNb/w8QijzB1wuxc4E091WiCnd8DQKeiYENpfHPEbbj+od1yKQsAKE4+XRZVzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731947169; c=relaxed/simple;
	bh=+MIPZa/WS1dnRDJHPLvGJobn3N8vZKAcXRlhgnlpz4I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OC+U55WhJvkfnYkVu6VlkQgEsiYKQ1S/7RJo2bjpAuOR1jwfwoNVZl1sxsJIMAGCKMQ8rPP5pEUshZRZd3nj114tQb9VlTDbuu8AtgjWKQpociGLu0lwyGIo1QAUWnGN2KHqIDNX+M6ws1vCK4iDz/kmU29B9SgKYtmZs/4u5RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eqsbucZZ; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-72410cc7be9so15924b3a.0;
        Mon, 18 Nov 2024 08:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731947167; x=1732551967; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vR/V3jq51dcRx7aasJe7cmMY+x9dNJ7p+RSUeHs+0NQ=;
        b=eqsbucZZ1lIqoqL0j4j5Qpg6HpC9Vdl1NkDZtpUH4CScgaJo4jBhLu5oH17EbMlicq
         mPohFqWPLUUXWSwSqhEE3nrtk2JqcdxzU3gU7IAEjE4gIQOFpREbixEnXwk3ZPwnJla9
         9ywpGhh7HhKRQ/ySftjQe9pJkdA6Lp/ufWKHRcF6Dg3ExgJ/gfm5N1kpxS5T6MC+ou9M
         n5DFeozuOp6yDxW5xUepHEUf4HQV+l9gn9ag43qbgXdOhFQqaMSMy2gXs/1qj+aQwM2V
         A3Yj1o8E2q++VyiQB1MTB/orj6sDLPszv7UtMzm2GKg9I4AJvishuXw6a01teTDkjZCy
         ZtaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731947167; x=1732551967;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vR/V3jq51dcRx7aasJe7cmMY+x9dNJ7p+RSUeHs+0NQ=;
        b=u4Q39njPLA7TIhWCSElkrpyTjo1MJwwQukEQNw29RJ9DSB6xm+uKyxuPEMvx4bY1iV
         u9NyQ8Rgfde4hXJcUXdRC6rAY9W2Kw8E8rrEw6DXj2txbTOCHqFb/8GkULaxR68tOAdK
         SoblI1QXPxctf2wNML5hQ7fBGJ7z14nrOATa7r/ACvpnjhRYYsFI5D2T4BTGBdfwEuqX
         E4qyX8WSsQMktTH8GXs8ADrqjBBVItgmQYNvbsWKtBfNCj1MTReNjzbsquGk2drGaaDz
         v4h5LiKZunt38T8lYRmw5FNK//n/kQMX8TXv3+FZRpoxpmErizJxxa+JOCcMm9HqvJ2Z
         18NA==
X-Forwarded-Encrypted: i=1; AJvYcCUEVvRfnC97AghsaxEl+V8NkV1efWBIm4bX3P6JiY5QMX4ZXVrdkdVW1IIUQN2EtwgtbwgKxBm20UVs@vger.kernel.org, AJvYcCXI+mWyV8GZhe3EimAdKW+mjXV7h+N+EjHmlMGr/VXhWd8qB9TOTnvNnNY07Gn+f5djQ7fF+58vQodi1jq2@vger.kernel.org
X-Gm-Message-State: AOJu0YzWKwg+eqqH4We+G5bAy75FUVu3LzH3o58DpQqZjlY4iK0VcB6N
	VpWbriGqmKRCP7rxICcUEe7M+mFoHIXwPLuJYZLaX7pXySnp4XlqYb2s/f0P6LwDNmCd9WyCz+P
	9fbjHtm4y7b0iHdWxj0F/D1uLTVmKuis9
X-Google-Smtp-Source: AGHT+IErG0e4N0ajHYpzefaiB9xQm15ZxHHlJBgv0c6W+rc0B+j96DKYXunmrb9G18o5r4XMYWTth0SQ6vcC9yJWpik=
X-Received: by 2002:a05:6a00:2309:b0:71e:7745:85b8 with SMTP id
 d2e1a72fcca58-72476b721d1mr16788885b3a.1.1731947167313; Mon, 18 Nov 2024
 08:26:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241115112419.11137-1-abdul.rahim.ref@myyahoo.com> <20241115112419.11137-1-abdul.rahim@myyahoo.com>
In-Reply-To: <20241115112419.11137-1-abdul.rahim@myyahoo.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 18 Nov 2024 17:25:55 +0100
Message-ID: <CAOi1vP9dCx5mpjZ3RpKZ5z1zYYW9SbH8DWWtRD9J0xcEmerFpw@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: Use strscpy() instead of strcpy()
To: Abdul Rahim <abdul.rahim@myyahoo.com>
Cc: xiubli@redhat.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 15, 2024 at 12:24=E2=80=AFPM Abdul Rahim <abdul.rahim@myyahoo.c=
om> wrote:
>
> strcpy() performs no bounds checking on the destination buffer. This
> could result in linear overflows beyond the end of the buffer, leading
> to all kinds of misbehaviors. [1]
>
> this fixes checkpatch warning:
>     WARNING: Prefer strscpy over strcpy
>
> [1] : https://www.kernel.org/doc/html/latest/process/deprecated.html#strc=
py
> Signed-off-by: Abdul Rahim <abdul.rahim@myyahoo.com>
> ---
> Changes since v1:
> - Added third parameter in strscpy()
> - Added comment to explain where the limit `NAME_MAX+1` is comming from
>   as suggested by Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>
> Link to v1: https://lore.kernel.org/lkml/20241111221037.92853-1-abdul.rah=
im@myyahoo.com/
>
> The function __get_snap_name() is assigned to .get_name() from
> struct export_operations, when `ceph_snap(inode) !=3D CEPH_NOSNAP`.
> `struct export_operations` is comming from `include/linux/exportfs.h`,
> and according to [1], the operation get_name assumes that the variable
> `name` is pointing to a buffer of size NAME_MAX+1
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tr=
ee/include/linux/exportfs.h?h=3Dv6.12-rc7#n203
>
>  fs/ceph/export.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> index 44451749c544..96421f2b6cec 100644
> --- a/fs/ceph/export.c
> +++ b/fs/ceph/export.c
> @@ -452,7 +452,11 @@ static int __get_snap_name(struct dentry *parent, ch=
ar *name,
>                 goto out;
>         if (ceph_snap(inode) =3D=3D CEPH_SNAPDIR) {
>                 if (ceph_snap(dir) =3D=3D CEPH_NOSNAP) {
> -                       strcpy(name, fsc->mount_options->snapdir_name);
> +                       /* .get_name() from struct export_operations assu=
mes
> +                        * that its 'name' parameter is pointing to a
> +                        * NAME_MAX+1 sized buffer */
> +                       strscpy(name, fsc->mount_options->snapdir_name,
> +                                       NAME_MAX+1);
>                         err =3D 0;
>                 }
>                 goto out;
> --
> 2.43.0
>

Applied with minor formatting tweaks.

Thanks,

                Ilya

