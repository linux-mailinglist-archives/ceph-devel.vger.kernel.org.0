Return-Path: <ceph-devel+bounces-2197-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DC4F9D8887
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Nov 2024 15:54:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E3E8281F62
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Nov 2024 14:54:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B0EC1B218F;
	Mon, 25 Nov 2024 14:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k8JY54lu"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC7E1B0F30;
	Mon, 25 Nov 2024 14:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732546487; cv=none; b=THrAlPcpGcsQl5dEhuPlZuYlpMkykHNg+ofB7AYE1t3UsVptNvFBS7l7IO35buQsGSxGHupmdPIlgYT7luh44ZW6AJ0TWfjW1pjYvfJskOyjOcu5gqkCQOzoTYSE+Uov1AD8WqoRK3fwdslYCEbre9CyaYu/CTBPdMxx2t/r+iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732546487; c=relaxed/simple;
	bh=h62GJiiD4QtYtfl5PMZhNRB3INkM9vnJN/DBNDMKy8g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b3FqwkGp1BSQb/9IWkC9N0o3lGknZfDuHPfg4DWZj3XcqcDud7APy8yG6Vt5oI6v8icqyXvhSYsF5T0fBMxd5rHeyY4Lb7Og05tq80pywLT603R2KEvrasOmwG4tjnOYCPveTah/wq35fBAjTtUi98tTWRIWDVs5RdItiYkNfZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k8JY54lu; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-724f383c5bfso1705237b3a.1;
        Mon, 25 Nov 2024 06:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732546485; x=1733151285; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HOsENWN+qB9Dx904ObWc5CL8VY8bYYO2Iki/1LBieP8=;
        b=k8JY54lu0sf3Zy/F02gXZDmNfXLcr/K9qAZWGG+XJy/pswPZkKA81hVX4lrKhYOhsi
         iATdp6EagpfUQoRobM9TvyB1hDTJXuBxOejJtOVDF+FCoczha9K/RhMGf465pfHAZ7tV
         z1BkGkzgUbKT3F97TlQVbGJy1Eb5WNXL1+uQV+UxlaoAwmOwUpUn+8e5DB1MQxk5oPZz
         JWyVhcrt2L80p52c/jxHmsuJ5pEVvBANPLsxR4m289UmUbFVr3dRnz08aYibdUZPbn6v
         T/xdGfa63RonSQdF0byTdcEzyk5u+mdJIgnUguolHajQW4yWVLqSXOTQhitThb1x0xgU
         NvHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732546485; x=1733151285;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HOsENWN+qB9Dx904ObWc5CL8VY8bYYO2Iki/1LBieP8=;
        b=rd3Tmifka+3o/YNoKyd683V5buSHqgvzFk+ldn27DpI7Co+1nHzn3bkMOLuasa7v0G
         jOcYXSWYhuBEbJUXdw6nH95ZJYUsd84ZVTVRlwfnlqP+GfoDkQ4qxkrAhZ7xiWIhrGQ7
         SVRSPqNCLOle342kyj8ZhsesJ6hNnt2HddwnVU4MMtImu1erKBB0rB3k4QAlYQj/uLog
         Uh7sxuyheifMg0NUCCaOwe1jbj+uPHH1HiyrfCFEl1VyIZOBIsnmjUimAhmwLmmJ//B9
         b0PjP9D8OouJ8vSp35va9E4Y/nycgs6WL/5sQxLl7fIOiKOlS+jwl23uNurFj63Nh01j
         uvcg==
X-Forwarded-Encrypted: i=1; AJvYcCUPPoVjZskdxJv6zNamixVjllvvrc62iMY/CZav0tSgB+h67KL0Q1tVUnqUTxZ53ggxcVq81rz/3qyt@vger.kernel.org, AJvYcCWV56a1dYjje3kkzFDs8o5msi3j34gVgcX8yCPknGAWlfoIuYgcCWbG773JNdMY2p/BBb8QBg0bzT2tEhFZ@vger.kernel.org, AJvYcCXKCfTpDvYxerJN16tWrb3TQkKi4bFcQi9w9TkA7CrZa9yH7ncx00zs70bRHwsx9pSI9B0+OD7k@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+Q/4qqngPXw0spajyFaUlsLqWAvOhZjshS8ClMfSKcNcSqnQt
	L6sA4Uea6PiEWV6qnMs/OjqtYiq2Bf69CpA8oDVhVskQr506VMI5RixJaGVis1N1kMVjXtVOc54
	HOaLE8P1yIKzdkx/mjB9JUGMgyQo=
X-Gm-Gg: ASbGnct8v6gMZwMMCQV6iUgis9lMO/aNWhFetG9nt4Os8ySnQ+9k8R03KRZeIuRjLFF
	s37/6Jq/L/bH4A0CIsS1qIFmZSKrCvHQ=
X-Google-Smtp-Source: AGHT+IHfM+hogcFqtA02lwFZFzzWLQOG6/0Fq2qS4CMdqopt8lANaTAHer3Dp++Pc98eJJCuC7DUmo66YcOhPkyI03U=
X-Received: by 2002:a05:6a00:10c8:b0:71d:feb7:37f4 with SMTP id
 d2e1a72fcca58-724df4db5bcmr16210558b3a.6.1732546484962; Mon, 25 Nov 2024
 06:54:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241123072121.1897163-1-max.kellermann@ionos.com> <32d12a9f-d2c0-45bd-9f9a-e647a2ac7083@redhat.com>
In-Reply-To: <32d12a9f-d2c0-45bd-9f9a-e647a2ac7083@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 25 Nov 2024 15:54:33 +0100
Message-ID: <CAOi1vP8oMkz4pgKXHD2MVreMEr0H6yHaQ3Vn=JZ1eXxtFPw_6g@mail.gmail.com>
Subject: Re: [PATCH 1/2] fs/ceph/mds_client: pass cred pointer to ceph_mds_auth_match()
To: Xiubo Li <xiubli@redhat.com>
Cc: Max Kellermann <max.kellermann@ionos.com>, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 25, 2024 at 1:53=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 11/23/24 15:21, Max Kellermann wrote:
> > This eliminates a redundant get_current_cred() call, because
> > ceph_mds_check_access() has already obtained this pointer.
> >
> > As a side effect, this also fixes a reference leak in
> > ceph_mds_auth_match(): by omitting the get_current_cred() call, no
> > additional cred reference is taken.
> >
> > Fixes: 596afb0b8933 ("ceph: add ceph_mds_check_access() helper")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> > ---
> >   fs/ceph/mds_client.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 6baec1387f7d..e8a5994de8b6 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -5615,9 +5615,9 @@ void send_flush_mdlog(struct ceph_mds_session *s)
> >
> >   static int ceph_mds_auth_match(struct ceph_mds_client *mdsc,
> >                              struct ceph_mds_cap_auth *auth,
> > +                            const struct cred *cred,
> >                              char *tpath)
> >   {
> > -     const struct cred *cred =3D get_current_cred();
> >       u32 caller_uid =3D from_kuid(&init_user_ns, cred->fsuid);
> >       u32 caller_gid =3D from_kgid(&init_user_ns, cred->fsgid);
> >       struct ceph_client *cl =3D mdsc->fsc->client;
> > @@ -5740,7 +5740,7 @@ int ceph_mds_check_access(struct ceph_mds_client =
*mdsc, char *tpath, int mask)
> >       for (i =3D 0; i < mdsc->s_cap_auths_num; i++) {
> >               struct ceph_mds_cap_auth *s =3D &mdsc->s_cap_auths[i];
> >
> > -             err =3D ceph_mds_auth_match(mdsc, s, tpath);
> > +             err =3D ceph_mds_auth_match(mdsc, s, cred, tpath);
> >               if (err < 0) {
> >                       return err;
> >               } else if (err > 0) {
>
> Good catch.
>
> Reviewed-by: Xiubo Li <xiubli@redhat.com>

Applied.

Thanks,

                Ilya

