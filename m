Return-Path: <ceph-devel+bounces-1265-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08BD68FB7B6
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2024 17:44:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6100928331C
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2024 15:44:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92FDD144313;
	Tue,  4 Jun 2024 15:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O5x9wBfG"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4C013C9CF
	for <ceph-devel@vger.kernel.org>; Tue,  4 Jun 2024 15:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717515865; cv=none; b=C/SRo56Tf0py5+/KWDvlfZWQenEuEdW1ukFdpk5SVxiT7iKTCEhqEZrfpAJjAI2A8NkWZ46+5Xn8MGgZedBf338vDYYz1t2+wLBLh0e6o9Sb9rvuZzzTVSU9Q9ihrPoaiHZggnSaNB09LVqfTgDyKUZPGlI4sSup7HSJVUPSJPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717515865; c=relaxed/simple;
	bh=QD1J//h8tQdo074E0J0laZ4AfjORkp8s15b/n3/HjMM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k5ZDa8+5y1TMTrWtY061q5Bapv2Dj6zx3jP5DMvI9yf814me/bSmEdir1f0K17l9RvR0PY2cnmFuXDfzsTXFMFzohWmIiebVlmoWqldzu/tsNMS1JPOvGU/jgCcsbM8KjRvkuE4iP0sgZHzpHuXV4+hhfnsOS5NandX8gDBz1nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O5x9wBfG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717515862;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UxuL7apbG1hgJ1mZ84Pc7untQLBZaPpvNK0/1eeeriI=;
	b=O5x9wBfG+1g++djlgsbIdHS4Hn/6Uv909z7vrhttv6i96wsb1fWRhAwNa4hcuoeJrb2rUN
	lRMzXiOQX8k29P9DMhcCW8nJeNknEFXZrbRPkBMhiOMvb7++Y1afSTVvzz9BnYyyk3enXc
	cDUjiWjfjAZjAzlZqJAIROdejm+8LpU=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551-4wRlsErbNTikX29PJrb3LA-1; Tue, 04 Jun 2024 11:44:21 -0400
X-MC-Unique: 4wRlsErbNTikX29PJrb3LA-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a68afe5b95dso177007666b.2
        for <ceph-devel@vger.kernel.org>; Tue, 04 Jun 2024 08:44:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717515859; x=1718120659;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UxuL7apbG1hgJ1mZ84Pc7untQLBZaPpvNK0/1eeeriI=;
        b=nr6FU6vRF/NLSXTuWsl5faqMPXmNN3lVUt3f58zrCr/c7zJIPMLoMTRuzzPgXFaW4x
         /dGvXR/jhekX4xNYNkWnSWL/Nw+OHX0Tkwhw6VMD4GlpEmK4YYIkKpABDh5uettuyda9
         dH9NP2QNVwuNl0ZwO1IXhaHq/uM6dX+LCUO+IPKbLYvk5Ew/PEpfM+j0KOK0lPLjsJ4z
         YLcSdjCkDH9ejCoUZSc2m/EmKYX96Hka8SeKAjKm/ndbdegI5tQAAwfV61XsLRWjXrih
         mPtFiFjcIK1cMJxRotAM2O9M565820mNYUpqseQicxIfyHkqCYIr3REBIAd945VaqDHc
         er1A==
X-Gm-Message-State: AOJu0YzmkLYLeSYvwcz5Axj0p7eGuxwsooIyhO+IerdBVDcpdcHbAObQ
	rRhExuGdfaEGQfEAseQrMa4C1IxNdX8bnYT7Y5s9mG/so/hjgetClcxNB/XND+1G4qBKoimmK70
	Ev2cHSheQZ0Ycfbo2Dj/LP21J1KKE21+D2dIRjVgwZjmycXfv/8fib2TzuPlmI9NlMJ6J2mqeJM
	WI3W9KS8n3aib7T0Uj7MbVqC8wEfDGY0Qi6Q==
X-Received: by 2002:a17:906:69d5:b0:a62:b97b:b3bb with SMTP id a640c23a62f3a-a6822049316mr830294066b.74.1717515859335;
        Tue, 04 Jun 2024 08:44:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFzF6ahZV81xyF7FABjFabgBzKjFrviZBPX7bJjBHfCLUuzZeMOynt/RecaYhD8Z73UShqxC2YgM6gmBAqO5sQ=
X-Received: by 2002:a17:906:69d5:b0:a62:b97b:b3bb with SMTP id
 a640c23a62f3a-a6822049316mr830292766b.74.1717515858943; Tue, 04 Jun 2024
 08:44:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240508094349.179222-1-xiubli@redhat.com>
In-Reply-To: <20240508094349.179222-1-xiubli@redhat.com>
From: Venky Shankar <vshankar@redhat.com>
Date: Tue, 4 Jun 2024 21:13:42 +0530
Message-ID: <CACPzV1=o9zOtkw2NzVSFhVodZAE__8WAijiv0wuC1tyz5d5SkQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: defer clearing the CEPH_I_FLUSH_SNAPS flag
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 8, 2024 at 3:13=E2=80=AFPM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> Clear the flag just after the capsnap request being sent out. Else the
> ceph_check_caps() will race with it and send the cap update request
> just before this capsnap request. Which will cause the cap update request
> to miss setting the CEPH_CLIENT_CAPS_PENDING_CAPSNAP flag and finally
> the mds will drop the capsnap request to floor.
>
> URL: https://tracker.ceph.com/issues/64209
> URL: https://tracker.ceph.com/issues/65705
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 197cb383f829..fe6452321466 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1678,8 +1678,6 @@ static void __ceph_flush_snaps(struct ceph_inode_in=
fo *ci,
>                 last_tid =3D capsnap->cap_flush.tid;
>         }
>
> -       ci->i_ceph_flags &=3D ~CEPH_I_FLUSH_SNAPS;
> -
>         while (first_tid <=3D last_tid) {
>                 struct ceph_cap *cap =3D ci->i_auth_cap;
>                 struct ceph_cap_flush *cf =3D NULL, *iter;
> @@ -1724,6 +1722,15 @@ static void __ceph_flush_snaps(struct ceph_inode_i=
nfo *ci,
>                 ceph_put_cap_snap(capsnap);
>                 spin_lock(&ci->i_ceph_lock);
>         }
> +
> +       /*
> +        * Clear the flag just after the capsnap request being sent out. =
Else the
> +        * ceph_check_caps() will race with it and send the cap update re=
quest
> +        * just before this capsnap request. Which will cause the cap upd=
ate request
> +        * to miss setting the CEPH_CLIENT_CAPS_PENDING_CAPSNAP flag and =
finally
> +        * the mds will drop the capsnap request to floor.
> +        */
> +       ci->i_ceph_flags &=3D ~CEPH_I_FLUSH_SNAPS;
>  }
>
>  void ceph_flush_snaps(struct ceph_inode_info *ci,
> --
> 2.44.0
>

Tested-by: Venky Shankar <vshankar@redhat.com>

--=20
Cheers,
Venky


