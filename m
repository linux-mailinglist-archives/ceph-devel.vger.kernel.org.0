Return-Path: <ceph-devel+bounces-3081-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7283AAD12DA
	for <lists+ceph-devel@lfdr.de>; Sun,  8 Jun 2025 17:07:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FCA53A8FFC
	for <lists+ceph-devel@lfdr.de>; Sun,  8 Jun 2025 15:07:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E37024E016;
	Sun,  8 Jun 2025 15:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NUPBZdvD"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B68478C9C
	for <ceph-devel@vger.kernel.org>; Sun,  8 Jun 2025 15:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749395240; cv=none; b=rgdUMk+ttHsntucTER6Jd+nOy3w2pOY+yyW/PUewUiLc3DAjxEbaIv6hi4hmfX28vL+t+wTzv0p9m8ef9Ja/ULKMuvUWAC3UtFsQZH+x6aI9OYVKzrnanu3xs0TBSmtzAV2sccoCnwhw/SwwkrU59oGZPf5HXh/qSvtYfn3Fxis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749395240; c=relaxed/simple;
	bh=bWM3F234xLwCvNWi74EmLuLiAWakpD4gug5a93vVJIw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j5izONDHtId+sOAEw5ipUCsnYd++skc+I7GusQEY+URWsKsTHdVGnITO19E1KFC9Rv36jasPOs2/kvNfElyVIoQ81AgYcsrXe8OkZrFXsrTEqUf2FfzZtqd7ermnTNhAUFYBsrmuy+Kput33w5YTI+uEyjgMKpvwJur4u3xcl3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NUPBZdvD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749395237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qe8FdhFYZnl5uKznrvXsigqbG5dH1PHILMaKQyy33bQ=;
	b=NUPBZdvDzsbiJjxzdo7mf1pWZ1b0YNoTgvMBJU0rfd8bxtVoWnFRWhTgqhXooSuQ9p08Ux
	eXLYiBg063+Q21FjgQIM+/YJRGAIHvJf8/20Mn9w80lG3EMb+/jY0noI07ASKR41DrpbnU
	N4M/XfjsKjpnTolMQ8I1rFfcAimM5GY=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-279-F0G2nqNuM4iUD1NgACz3aQ-1; Sun, 08 Jun 2025 11:07:16 -0400
X-MC-Unique: F0G2nqNuM4iUD1NgACz3aQ-1
X-Mimecast-MFC-AGG-ID: F0G2nqNuM4iUD1NgACz3aQ_1749395235
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7d2107d6b30so475560585a.0
        for <ceph-devel@vger.kernel.org>; Sun, 08 Jun 2025 08:07:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749395235; x=1750000035;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qe8FdhFYZnl5uKznrvXsigqbG5dH1PHILMaKQyy33bQ=;
        b=JZh2erIrxPDf3T6faX01w/sQwCnUH+t2NpNH43ghdk7yhyRP97u4bs8qx74XGTN36x
         rUwpc199W9NLhDdFA6PkhhunCPv7YMxgn37T0DEUkLkNyyb2+6NSc+y32UefN9WHtT9l
         CKywvNUHjYyBc8PpT1OYdc+be1BrpUxDXFHJDxtHoE3dwkkX55pWToIKTGFllHXt0y0u
         d/IaLRABPsua4feqY4HHm+Ui/a1lR5BlNnDl7nXGwyfkHggw6yau3m4YcT+LJ7a2hgGB
         RLvXhN2c8SnACm63UNcEGH0ffxL4GF6uxjnfNCOe9tyb8tfxh5UzCZWiNWugNIP4AIHB
         yszg==
X-Gm-Message-State: AOJu0YwwkUiGSjuEJAMU/xzOVddLQtY+qYkJewa70xR09alc0PMgp+1a
	IRAxS/JZJEeu7D7NiXwVxxcJu+QlrqM16GR1iHy9A3B7992QXeuoa+5lrTI647+1pprxBv3T1y4
	LyJVYeIlnK2S56a4HvWy/G0kHEd2gX3/zAC7NM6eBbtiJC38B3wFlb3QMLhIiUDM77opZSZfCHe
	brEEB/09EONsZzJmwsuqpW8ud64wDduvLf073fWw==
X-Gm-Gg: ASbGnctIzIOi7hhoiO95wmWAd9eUaQ4X73EDa8+GtdJiVsoKglU6InshwREa2yqSazE
	+bR5HFcJFcSgMmLFIqtUzSFnzx4K/Q+GzS8IgPPnCa/3RQjHtEm0LYPsXsfvNb9OKMzQcyHsoIy
	QcZps=
X-Received: by 2002:a05:620a:4447:b0:7d2:25df:4e30 with SMTP id af79cd13be357-7d2298eb391mr1734443385a.48.1749395235456;
        Sun, 08 Jun 2025 08:07:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFndNHijDgv+d3Mmf8A9vptGVGLU273o7QFaSjhBtY1oc/gyRzlk2eHmaZGE5nkf7EK+zh6gnx0L7wG5IDNUno=
X-Received: by 2002:a05:620a:4447:b0:7d2:25df:4e30 with SMTP id
 af79cd13be357-7d2298eb391mr1734440885a.48.1749395235194; Sun, 08 Jun 2025
 08:07:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250606190432.438187-1-slava@dubeyko.com>
In-Reply-To: <20250606190432.438187-1-slava@dubeyko.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Sun, 8 Jun 2025 18:07:04 +0300
X-Gm-Features: AX0GCFsdf9pnv04pEi6pK8zoebl06DM9Jqii1jy1KXPxQIwSvgOtkUp4A4H2Pgc
Message-ID: <CAO8a2SjAv6TPwVRurTgBq3D2N=N_F=-PBy=Qk=aEesgBkPfgzA@mail.gmail.com>
Subject: Re: [PATCH] ceph: add checking of wait_for_completion_killable()
 return value
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, 
	linux-fsdevel@vger.kernel.org, pdonnell@redhat.com, Slava.Dubeyko@ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed by: Alex Markuze <amarkuze@redhat.com>

On Fri, Jun 6, 2025 at 10:04=E2=80=AFPM Viacheslav Dubeyko <slava@dubeyko.c=
om> wrote:
>
> From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
>
> The Coverity Scan service has detected the calling of
> wait_for_completion_killable() without checking the return
> value in ceph_lock_wait_for_completion() [1]. The CID 1636232
> defect contains explanation: "If the function returns an error
> value, the error value may be mistaken for a normal value.
> In ceph_lock_wait_for_completion(): Value returned from
> a function is not checked for errors before being used. (CWE-252)".
>
> The patch adds the checking of wait_for_completion_killable()
> return value and return the error code from
> ceph_lock_wait_for_completion().
>
> [1] https://scan5.scan.coverity.com/#/project-view/64304/10063?selectedIs=
sue=3D1636232
>
> Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
> ---
>  fs/ceph/locks.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
> index ebf4ac0055dd..dd764f9c64b9 100644
> --- a/fs/ceph/locks.c
> +++ b/fs/ceph/locks.c
> @@ -221,7 +221,10 @@ static int ceph_lock_wait_for_completion(struct ceph=
_mds_client *mdsc,
>         if (err && err !=3D -ERESTARTSYS)
>                 return err;
>
> -       wait_for_completion_killable(&req->r_safe_completion);
> +       err =3D wait_for_completion_killable(&req->r_safe_completion);
> +       if (err)
> +               return err;
> +
>         return 0;
>  }
>
> --
> 2.49.0
>


