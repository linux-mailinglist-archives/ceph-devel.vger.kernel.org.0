Return-Path: <ceph-devel+bounces-4244-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A3D0CF3AC0
	for <lists+ceph-devel@lfdr.de>; Mon, 05 Jan 2026 14:01:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1FA2330B40C9
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jan 2026 12:55:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33256330B3B;
	Mon,  5 Jan 2026 12:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U41c3r2A"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F267207A38
	for <ceph-devel@vger.kernel.org>; Mon,  5 Jan 2026 12:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767617521; cv=none; b=Q3R8BuN3s5fmXypV2XxcFhO8uf0snVXJmGbqErSORU9FApRPvNmXWVOL79mH0DECqyw9DyIWFPf1u7tf/iQ7YQe21gsVl5ullwOT7mW3BRg1q7dSPgCNJ/N3eCctPGB09CfrKH1TY9XjrFrM1CyL4EsHwylfTp8Q+yFHZ4gdiBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767617521; c=relaxed/simple;
	bh=4KlXMDvVk2Y9UNsBqpwH+8dwYAskJr0J9c/xBNsrefc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rSPcnjENsqA9DV1HFg8hEVlXQD+spoXxrPkOhD8nw8lL6mVjJ7AsCjKYPE7c1IUfCQLYaOOkUX9HzlA67Ze1hEtvI2v/6foh95y8HaeaAYscdgTYgojxjwMIuEMQGZ3NzdQXFRbVRsHEBwjFAPXu97BCrvkguP7nIFtdGSUyCS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U41c3r2A; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7ade456b6abso11208977b3a.3
        for <ceph-devel@vger.kernel.org>; Mon, 05 Jan 2026 04:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767617519; x=1768222319; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fIoM2jDtI46cPfcnhs6SMUE4vjSExS5U4Rjxj3hmM7M=;
        b=U41c3r2AaWvX4xGAY9sIKpaMOC6864ynTLVc9LhWOGGzMPOWV1sJcT8gCx+SQip191
         Q3agzNKJSFgQa3BAkgroBefsM5PSfB+p6n1mKVpB+ILkm84L8nwZNgY8e6bFwuzU99f9
         EoPoCTxn64zCPWP41eb1WGH+qZsyrPzk2QWRvu410HmmtsAFa/I1AB6RNrdzyVN+mOlX
         hVZr2vkft+Rz14aNuboWsDPacY5tRdT3wUruZEMwT94Ju7iyIOcdUy8MKQQhsTPVu7go
         +ylb+Q0E3ToTGXQxrob+V3hZMbiL2bKl3Ead8vela3RijYs94DLoJWbo1jF/BguzzaCh
         sRiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767617519; x=1768222319;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fIoM2jDtI46cPfcnhs6SMUE4vjSExS5U4Rjxj3hmM7M=;
        b=cX8mRs0baHMUQM43pkafJCY2h1IUcDfPN5sidp5EWoAAgPffxZEEVBmWH9XSdEVlQw
         rh9FDROwxNTIWGKYnLuQJMQqw8lIglxLa+UH8+QCqC6FQXpytcAhlxYYWDUVkH9jYtF0
         +5yyf2y7GZTifKrNhtVSvTsoN0QPoJz7mAGzErG9sMeDWZvw2buoL7qcLhWl/jEOsxiA
         GRaVjmn39S3Plzmyno5qEPcT2dQIblnc6dOgeDan5ldc1pnmvFJtmcnp/c3y4FXRDoGM
         luftWXVJrmDr5M3Lqt3X3vcFSXQifBu5lmkG7Rzn/xXjZ437KiueRXmjUSwdH4Iwq1OO
         Hggg==
X-Forwarded-Encrypted: i=1; AJvYcCW57kdx4zAbfk5LL07Qp2ksoyM5UnbEOkncI+zGu4WrFgiaYQgRkyfdU4GlNSVjKG16wt/nVSh9iZR0@vger.kernel.org
X-Gm-Message-State: AOJu0YxID12G15NWtFczlpBOMj/Y24UhkRQgTqJ/9C+acx5W1/XaK5Ca
	M3k2J8HV4HCuprck5X+nRkMoVA9rNejsRbkI4hs3ma02468NPJ2NutSQueHUMqUKOPp5d0HxFDF
	QXLBls4g2PuZFBu06GN3zEC12bMZ67G0=
X-Gm-Gg: AY/fxX6CM+SZGC+41X4GRwkmieyAcKBTPyk2Peg6dwbeeWV9tuQQhpE1iAecBBV4VJX
	LxLWokXKU+McY2Y4zvZmCXGr9uq7WC/EQOz8yssQ5YTvjfWwsUcgzNYy0YaR1wDEcw1JsLu5Cjw
	s/a5i7MXe/S0CcXM68uuEUQsPo8kFKQxyt7CNWbloLJTWvTgApiZ+RR2pT+hvWxFiwfRmvvupMa
	gNkkqNKK/lMqWZsN/x0ZNOsISdKLRMaOZdBwLnP1whECMSvscv0cQrRzZJO+CRVlh2PLqQ=
X-Google-Smtp-Source: AGHT+IEXerOKeKOtB2sspI6kFR5QkFJ+Zr+D0dSc5pMahKMWycdWJvhmtT1SmXyL/YXhI4p2gm1GSa3b4G+p2WkMb2s=
X-Received: by 2002:a05:701b:230a:b0:11b:9386:8254 with SMTP id
 a92af1059eb24-121722ec414mr44206169c88.41.1767617518832; Mon, 05 Jan 2026
 04:51:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251231040506.7859-1-CFSworks@gmail.com>
In-Reply-To: <20251231040506.7859-1-CFSworks@gmail.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 5 Jan 2026 13:51:47 +0100
X-Gm-Features: AQt7F2q47D6R4WXpHK6TLAOa1OdzRxSgQoSFN7TMgW_O5ppNSIvanQB-2ttegeY
Message-ID: <CAOi1vP8WvK-0nGjKY6ss2MX6ZjvDOhcur5SyM=E=uipW0fy76g@mail.gmail.com>
Subject: Re: [PATCH] libceph: Reset sparse-read on fault
To: Sam Edwards <cfsworks@gmail.com>
Cc: Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 31, 2025 at 5:05=E2=80=AFAM Sam Edwards <cfsworks@gmail.com> wr=
ote:
>
> When a fault occurs, the connection is abandoned, reestablished, and any
> pending operations are retried. The OSD client tracks the progress of a
> sparse-read reply using a separate state machine, largely independent of
> the messenger's state.
>
> If a connection is lost mid-payload or the sparse-read state machine
> returns an error, the sparse-read state is not reset. The OSD client
> will then interpret the beginning of a new reply as the continuation of
> the old one. If this makes the sparse-read machinery enter a failure
> state, it may never recover, producing loops like:
>
>   libceph:  [0] got 0 extents
>   libceph: data len 142248331 !=3D extent len 0
>   libceph: osd0 (1)...:6801 socket error on read
>   libceph: data len 142248331 !=3D extent len 0
>   libceph: osd0 (1)...:6801 socket error on read
>
> Therefore, reset the sparse-read state in osd_fault(), ensuring retries
> start from a clean state.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sam Edwards <CFSworks@gmail.com>
> ---
>  net/ceph/osd_client.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 3667319b949d..1a7be2f615dc 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -4281,6 +4281,9 @@ static void osd_fault(struct ceph_connection *con)
>                 goto out_unlock;
>         }
>
> +       osd->o_sparse_op_idx =3D -1;
> +       ceph_init_sparse_read(&osd->o_sparse_read);
> +
>         if (!reopen_osd(osd))
>                 kick_osd_requests(osd);
>         maybe_request_map(osdc);
> --
> 2.51.2
>

Hi Sam,

Good catch!  Applied (with the sad note that support for sparse
reads is officially the most problematic patchset that ever made it
into libceph).

Thanks,

                Ilya

