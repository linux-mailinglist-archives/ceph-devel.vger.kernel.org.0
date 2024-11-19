Return-Path: <ceph-devel+bounces-2182-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 026F99D2603
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2024 13:39:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC1BA280F1B
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2024 12:39:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 916961CBE89;
	Tue, 19 Nov 2024 12:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kNW+ebQE"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E761CB30A;
	Tue, 19 Nov 2024 12:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732019943; cv=none; b=oQPhS8Y47VlJsb3RwAbWaITBGets856i4hQXwmGM9AjB39Sax3n8Gr1aO4PT9uTpLtuHbN5oRxT7/dbzSTuxatyL2K0VWj1wQzLS9YmYHq1eIrkNnObTSNIDagcuOsPU62OnaLSwgpPQ5d0KUFM/CEKsNphgqXevqlq5rFlYL9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732019943; c=relaxed/simple;
	bh=8iBqnQalMGmDNmE0r5Hr6zKEtbWAH9SA9qg6eJ54jYc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uC9Ha52NdS17lynbQySArPxQdWgmg3902aOumkeV8wNkLzPBGjJonuVVrvFsuVqndK3rZH7tLPSwDrPAI5nX6oIjVoyXZGWLryAYHu+ahgQ7uSNejNG6Vj3FyG5wVdkC30l6d2Y5qkFIBypl78dTVJnpBOFi9URdlQq6rcnEEUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kNW+ebQE; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2e9ff7a778cso3932826a91.1;
        Tue, 19 Nov 2024 04:39:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732019941; x=1732624741; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JnZ4qxtYlpHZEhiV3OA1KhsP1iSPVNJtA1zzeqy70e4=;
        b=kNW+ebQEfvoEAq07z3TbHMyi8tP+k1jUBCfmXCk2jvaYoWxTN2hUGJ4aU5fwXD/B0S
         qeH4g35hdOR6vRL9LF4XNGEUhT96lQ3fKPf7GjmtzgOvFGUykScaSA25xoY4SZmWsGvs
         3QSerAcvM4w8NvPu3eStDfJ1gGUqZ2oQJXHHie9KJcRHGPpEFDT+YuIhKy3K4FGoyjLa
         hHCoBBx+0mGamCx7uy2jUev1Mhpr55yIUiZqEeCD4lC3tSUx2oyfD2K1boapcPC6f/dO
         wo3mgLPP+Uul7sXFOdH/xG8fWk4E6oEJZsU9yFfSfR3Kn96K9EAl6B3x2619DQ2qxSZD
         1IIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732019941; x=1732624741;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JnZ4qxtYlpHZEhiV3OA1KhsP1iSPVNJtA1zzeqy70e4=;
        b=YprOMwTTfPMH+T9EhJ0Hjbm/2Zz/7YpGyRO4P5y3GKJTa3yDMGwjrZhipJ6FrIYa2f
         LXk6Kvcc6xeaWZAVZvJ/okZb7jf/Vty60WY3Wm6ue/JHPScgAdlN+6b2UjM6OHAF+n5r
         482CSCNm+2grrJHGrVYmsqTJfFe/Ra/91Qa19iQRkV9T2CzvkO3FHFJ0VFs7QNVBpFZt
         aiEau63UJNmpR/XMOmyWQs7mtsS92LkbyJwVazhZVZeOApMWtpnCtI2+Es+pwYup0Gm9
         Y2z/7nqLZLZl/82T56Ao5bFa+iEnYUib0l5qExSu6SE7i9c6zT9DsEhDvgH5W0ORQ6vC
         BhDQ==
X-Forwarded-Encrypted: i=1; AJvYcCUTK7OIsUE0WICs6k7YcEQef886EfIe2FVqMuz37/P53atPGiZABFAB45k6LETfJb8DBh021Ystf9qc9wHQ@vger.kernel.org, AJvYcCV2CLa9DYwSPHA8yxJTqWCsxHfBS2D8LBQGyGDMvwSFswdELMc5WT7EjJWEo93HGgAAxFsoj8EwgVsU@vger.kernel.org, AJvYcCXwTDVF1VZk4ve4NA021QOtX2hzPIT9ZSZwGxAu/D67XMY+iui7Aja0qmqiiolGG79nBGm1orAX@vger.kernel.org
X-Gm-Message-State: AOJu0YzGsnkZSQCm3svuv32m0xvK9iZy0okBoGE1qZrAL8LlxituINIe
	RaRSuT3XprWhTasnW7ykP7bSgJ8LXvnHoq673ndKgsDvAJ9EI50z2T71MKJrjEbw068SMouW1QP
	XqxhzS5JyAUKOTB64E6nIxRJ20/I=
X-Google-Smtp-Source: AGHT+IFkq5BsdRSYuU1Pl5Sb0f6LIlJ/9TRKK19i3Xu4IVqUtYGvNnBs8ndn12i7Jz3NjGug4ZtDVTSyuye4d/foe40=
X-Received: by 2002:a17:90b:4fce:b0:2ea:61c4:a443 with SMTP id
 98e67ed59e1d1-2eaaa73b935mr4703490a91.4.1732019941182; Tue, 19 Nov 2024
 04:39:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241118222828.240530-1-max.kellermann@ionos.com>
In-Reply-To: <20241118222828.240530-1-max.kellermann@ionos.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Tue, 19 Nov 2024 13:38:49 +0100
Message-ID: <CAOi1vP8Ni3s+NGoBt=uB0MF+kb5B-Ck3cBbOH=hSEho-Gruffw@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/mds_client: give up on paths longer than PATH_MAX
To: Max Kellermann <max.kellermann@ionos.com>, Patrick Donnelly <pdonnell@redhat.com>, 
	Venky Shankar <vshankar@redhat.com>
Cc: xiubli@redhat.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dario@cure53.de, stable@vger.kernel.org, 
	Jeff Layton <jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 18, 2024 at 11:28=E2=80=AFPM Max Kellermann
<max.kellermann@ionos.com> wrote:
>
> If the full path to be built by ceph_mdsc_build_path() happens to be
> longer than PATH_MAX, then this function will enter an endless (retry)
> loop, effectively blocking the whole task.  Most of the machine
> becomes unusable, making this a very simple and effective DoS
> vulnerability.
>
> I cannot imagine why this retry was ever implemented, but it seems
> rather useless and harmful to me.  Let's remove it and fail with
> ENAMETOOLONG instead.

Hi Max,

When this was put in place in 2009, I think the idea of a retry was
copied from CIFS.  Jeff preserved the retry when he massaged this code
to not warn in case a rename race is detected [1].  CIFS got rid of it
only a couple of years ago [2][3].

Adding Patrick and Venky as well, please chime in.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3Df5946bcc5e79038f9f7cb66ec25bd3b2d39b2775
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3Df6a9bc336b600e1266e6eebb0972d75d5b93aea9
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D991e72eb0e99764219865b9a3a07328695148e14

Thanks,

                Ilya

>
> Cc: stable@vger.kernel.org
> Reported-by: Dario Wei=C3=9Fer <dario@cure53.de>
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---
>  fs/ceph/mds_client.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index c4a5fd94bbbb..4f6ac015edcd 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2808,12 +2808,11 @@ char *ceph_mdsc_build_path(struct ceph_mds_client=
 *mdsc, struct dentry *dentry,
>
>         if (pos < 0) {
>                 /*
> -                * A rename didn't occur, but somehow we didn't end up wh=
ere
> -                * we thought we would. Throw a warning and try again.
> +                * The path is longer than PATH_MAX and this function
> +                * cannot ever succeed.  Creating paths that long is
> +                * possible with Ceph, but Linux cannot use them.
>                  */
> -               pr_warn_client(cl, "did not end path lookup where expecte=
d (pos =3D %d)\n",
> -                              pos);
> -               goto retry;
> +               return ERR_PTR(-ENAMETOOLONG);
>         }
>
>         *pbase =3D base;
> --
> 2.45.2
>

