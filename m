Return-Path: <ceph-devel+bounces-2202-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF33E9DAE9A
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Nov 2024 21:43:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F9581645C7
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Nov 2024 20:43:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8DB9202F98;
	Wed, 27 Nov 2024 20:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="QGatPruK"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D17A16132F
	for <ceph-devel@vger.kernel.org>; Wed, 27 Nov 2024 20:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732740232; cv=none; b=YsKhNLIEOwqB5Aohb2HcqpkuJ4hEMwAhfOxMdIpguoLpnqmPzkU993ji7oYjUfz+sFz8mvoYU245fNwnz4fJemB442fyQFoyIXtD1bzCUJPK1Wfc+2lyx3oaW5nylZV7CnmRtols9E0IICGVQRy4/Dfn9UmlPoJ7+3pa79L2kFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732740232; c=relaxed/simple;
	bh=gvDzDWwoLjKYOe+3nXVcN9rkQhMxMxJQfxXW9CEi4Dg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WX9K2rSHeYK6A1m+VQHANUNwWOfGUQSN1qBA4Ysz4xtQWnEhtpADliEoDA6fFEOIALP4kDv0VtcC1DBd56DTu0N0F5euzrFXzats9mzHqL2tlDuVd/Vh26Lv7zzLv9s25tuAWhKXkE2VRE5JJRDpzeg0q13skOz55f6p+/29/NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=QGatPruK; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-aa55da18f89so14164866b.0
        for <ceph-devel@vger.kernel.org>; Wed, 27 Nov 2024 12:43:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1732740228; x=1733345028; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gvDzDWwoLjKYOe+3nXVcN9rkQhMxMxJQfxXW9CEi4Dg=;
        b=QGatPruKJ0YuN3QBs5Ll+NULSbLjvWu4kk5uuH/JndLbuKRCtdci95iD1HeWCKadV5
         nQ8VQhTsflYu6WvGyxcjPy0jPSMw32br+9w/4gf2i26VimRYdnTwSBGdTi/+NS9lvsiR
         CksfO54/ZFotjYTcYpg/NOgCEJSuyIGWXaEWBPPZewkoObKFmzrVmMMupVizbXhWO/F/
         YK6rJwxtszNmDFhMaDyXLUZY3byOsnV9q2xsI//lwzRYTszideqQLPowQMsNb0jh6Ijy
         bZzur4wPUUKoedrIx3gtOSamPf/UWUwzb1fXGoAjmoLCcg+S5ecrPpvAAuZF9zQJuo8m
         TULw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732740228; x=1733345028;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gvDzDWwoLjKYOe+3nXVcN9rkQhMxMxJQfxXW9CEi4Dg=;
        b=dLUi5LN69clTVzGoQcB0xUxXFDW1OJtbFKiu/2lA+zOEGHxWgszZv2kBtvM74hFRmo
         hCxRp8/WsM7ympBOyZowQ88HrX9SxsuaN0N3CF/YR/iqD6YwEtiizoupQygwn9nQUzKG
         /5HaiGi4DBrHmTRhmdJEfZhIjWhjZUVG9E6wdjSak19wiTR7Zux3XQf/cDQ6qnp5rGq8
         ejSiv1GvNwGxFZDO442Q24F+ENU0d/IbFT6SoCgKo/a2XpYz/3CpMFlqyUVdYlYO+TZp
         bickNiVjkk8fJ7ZYEfLdAiVV0c2S5la9Mz1yThfbTz54tm0j0zUFPB6UYe/KMb6mt4nm
         fpew==
X-Forwarded-Encrypted: i=1; AJvYcCXw1p6TCYF6z7bvA3HsDXDDGTc/BZ1G4ITYe1sRDRoQDq66VhPdtHK/TzTXiSkf9ygvgtkH+Igx8FFS@vger.kernel.org
X-Gm-Message-State: AOJu0Yw48KvT6Sp1xkO1BdgkSAmmXkhz9gkziId/DdKPozSjFHTGWdxe
	XlsCaUuEuTAVOFN374PYyZCO7y330zpu9p+f7DcZF5p2Qm5ziJJB38kgGW7jRrqpi2m65V+xeqj
	txLuf9F20hc0PB3rda5ga5MoXCVoW1/YmELryYQ==
X-Gm-Gg: ASbGncvGttQ/TazA2NR4n2aPUP5mAXXTiyC9mVg+9ZR5MwhIf/Yomseku11hfkN3pQg
	UphGzwHZphdmR4a3wd5TMrv8wtlG5PmUFKaE4Odg+X/rJbWzyreuXbc5HzPok
X-Google-Smtp-Source: AGHT+IGpuWxQT+so7sHdDoKBZ/oNoLvCwstGLiSwb/LCehEnCsg8aSBbm4XVUTGKv2uvrB9jiH5IFMmZ4Z1lGRP/a74=
X-Received: by 2002:a17:907:7622:b0:a9e:d4a9:2c28 with SMTP id
 a640c23a62f3a-aa581061ab2mr300001566b.53.1732740228683; Wed, 27 Nov 2024
 12:43:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241127165405.2676516-1-max.kellermann@ionos.com> <CAO8a2Sg35LyjnaQ56WjLXeJ39CHdh+OTTuTthKYONa3Qzej3dw@mail.gmail.com>
In-Reply-To: <CAO8a2Sg35LyjnaQ56WjLXeJ39CHdh+OTTuTthKYONa3Qzej3dw@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 27 Nov 2024 21:43:37 +0100
Message-ID: <CAKPOu+8NWBpNnUOc9WFxokMRmQYcjPpr+SXfq7br2d7sUSMyUA@mail.gmail.com>
Subject: Re: [PATCH v2] fs/ceph/file: fix buffer overflow in __ceph_sync_read()
To: Alex Markuze <amarkuze@redhat.com>
Cc: xiubli@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 27, 2024 at 9:40=E2=80=AFPM Alex Markuze <amarkuze@redhat.com> =
wrote:
> There is a fix for this proposed by Luis.

On the private security mailing list, I wrote about it:
"This patch is incomplete because it only checks for i_size=3D=3D0.
Truncation to zero is the most common case, but any situation where
offset is suddenly larger than the new size triggers this bug."

I think my patch is better.

