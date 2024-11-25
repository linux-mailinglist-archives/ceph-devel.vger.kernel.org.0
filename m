Return-Path: <ceph-devel+bounces-2198-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A1509D8995
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Nov 2024 16:44:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BB1ACB2EC68
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Nov 2024 14:55:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEEA11B2192;
	Mon, 25 Nov 2024 14:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h0BavPVZ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5DF1B218A;
	Mon, 25 Nov 2024 14:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732546529; cv=none; b=qB1uNs1YS1RwT1qc8in4T2rviITIqiPQuJm2As0o9FCeEcjhlOiI28fyU3QtXV6X01UdN4Vn7J6hLNrEY9gfxnwoS6I+DVMBGJegn8jubfo1E+t5BdKTaacO0Xe3UNycNEweu9KLW3+FLggbYqza0hoqTeOWYJWTEPkfY+nmVco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732546529; c=relaxed/simple;
	bh=sIQb/Y0x9UQ69cq19uBbKakWRTlhaATD924pGVebmtM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QmcDCBy46KuFsgQntlafHQ1mG3N067zB9iOplKYKzS6ukNhMgImzo8rbUVtOMJ34SgNdWEgiDnF00j1WsdlTHdM63W3AIoVBxGMV1RT24EVYPFuZRDMWnNLdZRIDWCHrdNUbarWCJ3ps07rKVNa0/yNTBjCFCHaAhZVfAe5eZFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h0BavPVZ; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-724e14b90cfso2518067b3a.2;
        Mon, 25 Nov 2024 06:55:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732546527; x=1733151327; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PPUjaM6N4AD8d25lJkfaSKNh3KeF7GizQgXLksi6/Sg=;
        b=h0BavPVZ2pyC5g1reN2C80v4dQxEvuTgUZTgsGwRzLYBIFfv1gz/uJcblgXw7kP+dL
         bFmb+O5oDYkzgqNjXpB0DgjVKmEBSrE17Ma7EJdMVntJvK0yxWcbZfwnEgmqwuSp+AGY
         2olk6zMh90N+Ee8FJvANiDTZwXewiEzoDjVgZslKC7i3yp2xRbQaCRQZDRa+dgx4Rbvn
         IJzTq6DhMGKUCewtGOl38rw+nPQeBanM6sHDl7pYr430nCWtcMC0ZUUPRGv9Z8HvEi64
         Q6wvFjvLtI0eDVuagmGOQNvQObsbppa4FRovo5nlshrY6kRuocGu4QQszFqcfyddRPhg
         NgdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732546527; x=1733151327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PPUjaM6N4AD8d25lJkfaSKNh3KeF7GizQgXLksi6/Sg=;
        b=bvIFS+SRnoFL483m6BsdkUw7kHqXEkxP2/GraiYT8uJP11C5+fCEO1RNCmP5SMGfAR
         oGSirCSNSheftJ5quchOf6cqf8xv+HrDW5oP0q1X9IGfrDo5TdHCng5ZLSv8P1f974g4
         OI92+d2EPobLQr/cNYjtfzNnVDqj+ZIVoUlped6jn0Vu4mLBaoKZeyjOYXaarBlKb+PE
         I2hZdkQKWlkbfNXzqqNvuiEr2t+wAw9Srrue9tD05gRWXH4WhJg9OGIcifKKGapwNmwh
         jXqiuXmCrFHoFV+yd4DVTl3q+oIoijLw/DkVMXBAD7huziIsHGH17UazZtjcH9Ii4584
         S/AA==
X-Forwarded-Encrypted: i=1; AJvYcCUTjqnw3ZJL6fKs3g8BuMTBzzu7QPUAarpBJHISja9OKzYoA6OpO774iqGIxyAJ9csx+j307k+wnA65LEdW@vger.kernel.org, AJvYcCWgr6SnhHa93lCeQdzhd5K8xGSl34N7ajm55q7jWn/JTpoH/hnoiqcI4BoJYESWIvYpAxHDD8G8NS0r@vger.kernel.org, AJvYcCXTDBVyB9fn6wBzNLDUesKbzucKVvNjnST1qNioDSBbiqgCbgWz4P1mKH5q8ncHinZSUV0tQVsG@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9pA4WBDzgEpJG14DG/XDslplHb42bq+Wr4MyDpynOXbKKz+UU
	XC36OYrMbEQh0xZjxGCOnhnYnGqbntHz6LfFoZhgvgFAXAXdhdAo/XD8mJDM0tWHoLekIh9jxQJ
	Xyg9fw9tjW12qTSWbjUuL0R1Hdj0=
X-Gm-Gg: ASbGnct/bfb0B9+c/Rx7pXNtCGQfwMeOhdJu/0hGrmPz3FZcoMYfnPgF/+vgz6F6w4/
	0ITIHA3UvPLmMQpnkra1aJ+I6nQnA3to=
X-Google-Smtp-Source: AGHT+IFUskMEkMmWhbhYtDRkIjrFcnkfe6RxQOgsdijQID11hDBsYAHwqiwrvZ34DaJmKFQz2Yfwiruf7Fee0gdXFjo=
X-Received: by 2002:a05:6a00:230c:b0:71e:7846:8463 with SMTP id
 d2e1a72fcca58-724df6df471mr19329887b3a.19.1732546527612; Mon, 25 Nov 2024
 06:55:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241123072121.1897163-1-max.kellermann@ionos.com>
 <20241123072121.1897163-2-max.kellermann@ionos.com> <b52a83ea-6e74-4bf4-b634-8d77e369e873@redhat.com>
In-Reply-To: <b52a83ea-6e74-4bf4-b634-8d77e369e873@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 25 Nov 2024 15:55:16 +0100
Message-ID: <CAOi1vP8wH4g=e+ie-JHFh67R7kH3VO1hYQMcJ2_bHHg_o-51hQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] fs/ceph/mds_client: fix cred leak in ceph_mds_check_access()
To: Xiubo Li <xiubli@redhat.com>
Cc: Max Kellermann <max.kellermann@ionos.com>, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 25, 2024 at 1:53=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 11/23/24 15:21, Max Kellermann wrote:
> > get_current_cred() increments the reference counter, but the
> > put_cred() call was missing.
> >
> > Fixes: 596afb0b8933 ("ceph: add ceph_mds_check_access() helper")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> > ---
> >   fs/ceph/mds_client.c | 3 +++
> >   1 file changed, 3 insertions(+)
> >
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index e8a5994de8b6..35d83c8c2874 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -5742,6 +5742,7 @@ int ceph_mds_check_access(struct ceph_mds_client =
*mdsc, char *tpath, int mask)
> >
> >               err =3D ceph_mds_auth_match(mdsc, s, cred, tpath);
> >               if (err < 0) {
> > +                     put_cred(cred);
> >                       return err;
> >               } else if (err > 0) {
> >                       /* always follow the last auth caps' permision */
> > @@ -5757,6 +5758,8 @@ int ceph_mds_check_access(struct ceph_mds_client =
*mdsc, char *tpath, int mask)
> >               }
> >       }
> >
> > +     put_cred(cred);
> > +
> >       doutc(cl, "root_squash_perms %d, rw_perms_s %p\n", root_squash_pe=
rms,
> >             rw_perms_s);
> >       if (root_squash_perms && rw_perms_s =3D=3D NULL) {
>
> Good catch.
>
> Reviewed-by: Xiubo Li <xiubli@redhat.com>

Applied.

Thanks,

                Ilya

