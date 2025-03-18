Return-Path: <ceph-devel+bounces-2953-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A4BEA67C7E
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Mar 2025 20:01:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A05217B84B
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Mar 2025 19:01:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96CFE1A5B8C;
	Tue, 18 Mar 2025 19:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="n3X49hfK"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CF11DDC2D
	for <ceph-devel@vger.kernel.org>; Tue, 18 Mar 2025 19:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742324460; cv=none; b=cLpMC6C1tbrpQ5wweMICrGZuEI4sq7EmdjrtMG9Jf3pTbFlAxX5LgBcL966SH256gQF6nj3HhdpXPGeQCILP1MEOejGbFcFFIPAuW8e1M3T3cAswXQ/CBmSqgPgzIiFPHa+gyFCL6o1eBKD2Kv3xjs6Pxs8RhTpt2r2meNFA2PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742324460; c=relaxed/simple;
	bh=wu9ejP7KKX/356JHQDIToZU2GavS+i7shgmdT7PwWbg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=g4Bp724OgLo/2N8eCt6DNLFKsOb72FEvL/4h1/5ofXBUnJBmthwOP6+4t0iH38UNjHdME0VyXYBR+Sjs0ctelCYp4vnKqDCChQFOjHQNxuxMsTqcfTKwijpRhLYi7OAWiI8SGPN4MaWRDNvr1VI8+jIW6ITkEL9+aPXh09o1cK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=n3X49hfK; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-601e77a880eso433097eaf.2
        for <ceph-devel@vger.kernel.org>; Tue, 18 Mar 2025 12:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1742324456; x=1742929256; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wu9ejP7KKX/356JHQDIToZU2GavS+i7shgmdT7PwWbg=;
        b=n3X49hfKjObdIHrkUlI8PvuA+qlfu+jp2lughWrUGefwlqrRZnolSTzDA921da5xt3
         URFg60E1BtLwXl+ykNZm8MJbWuTAgKMgsHdkub/BOUHqeQU3uObu3Dd+Lx/lrCFV78i6
         Qe8wWFOL3I78Ry/yfBluPRhqWe4DMxNz1F0mu2pkoD2ij/aAQNH4UnxuuwCQa0AWE3aB
         lZbIFeu6GnrnctrNBcViWP6uvEYNzfEJDBWGU2c8akHbEWX2X8LpEqcx7SJv148akq6X
         GMdagIkhBM5vLyXaCq62KewxycfnwqV9LRlX+XbU8SqEnJgUIQXwg3R/cdVjohA3iCf7
         TTwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742324456; x=1742929256;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wu9ejP7KKX/356JHQDIToZU2GavS+i7shgmdT7PwWbg=;
        b=CS0v48hH/N0Jy/wNMyDfov0sIaUs8wjn778MK1O2O8cgAAjgTDRhGpVnNDeK/AN1Qd
         YgFOLjelG4oSanwiq+QxC5/xZuM66hhaahgl/VOsBb+VpFnEn9QRQlbcCaMHTCYTcRoe
         UeC4m3nm8e28/t+KmkEEuoxjm7GLsv7s8VaLX1pmCGGxB9M+SKXXEPgtcB0TvgYGTwxe
         y5Cw3a/9h/jv0J54fxLcjyZzryjCmgOQ9d/s0yt5snNWp/0DmKqLL0SbRejdo/yXAVj5
         sIIBa+6uwHRSCb4Bv0Q9R7rydODAHrahKwySX8ZgycgErnCrJcyYh+I4+9hnFRjL6kGv
         Nfxg==
X-Forwarded-Encrypted: i=1; AJvYcCVkk9f3Hu5Hi5l9vA/XsLny1ym9JsgQwjAk4pBntJfOxoJkT+7XpcwzrBVxL56NEFlmpqLGY9fOCK9p@vger.kernel.org
X-Gm-Message-State: AOJu0YxUWN7eHxWhDUYzUhySc4AUMdeDyajpMbHW6Owp1EVMUWPTONYC
	J+520YnqoKqovzul2PJuA96CrEclZbTh+830Up3yPkFKdkInXEtlm9IllUa55hY=
X-Gm-Gg: ASbGncuUXF2i/GW3pkNB2d5xyPMkoNDHniyc84zDK9zOopAq8w/j0OqqYXNMWhOa5X/
	Qc3MTHzijXom2lHcsms2kgCrFfLsbeOlaglpxcNeH//LGH3lk98s2TqdoxXRkn1INPXAZhCMfxs
	o4eubQqYQjkk0+gASBu1BjP3DSj6aWOYfpRSI+IO9JmSgMdf+2OFcqqaP/yKyAUjEqKQp0lWBYT
	oP9bbYUJoUaRqYhiPcFB/jH3Xw3J8jTAPX++sJqqRDufgB0UGEtvt8qG12RYJMDhIgXm/QMTnUd
	3uUJmoLDb6M9hJkFz69a0EUApM6UM/WzoOT4w1TyraeAKq6xLcbsNsENbDqFWuzlSq+bVmAPrVO
	l7Gfe4plC6+pNEt6/
X-Google-Smtp-Source: AGHT+IGbTOlTh2eSiAlxTr1zvu7NtBr3vt+5qsKC0S6NFwwlaAUvGZIh6L1yg7YqvXI1wE55JfC0MQ==
X-Received: by 2002:a05:6820:5082:b0:601:bf4d:86e6 with SMTP id 006d021491bc7-6021cc89fcdmr137940eaf.1.1742324455939;
        Tue, 18 Mar 2025 12:00:55 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:7a51:a450:8c55:68d0? ([2600:1700:6476:1430:7a51:a450:8c55:68d0])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-601db6598aesm2077956eaf.5.2025.03.18.12.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Mar 2025 12:00:54 -0700 (PDT)
Message-ID: <80300ccacebc13ee67100fe256b03f08dfd2819e.camel@dubeyko.com>
Subject: Re: Question about code in fs/ceph/addr.c
From: slava@dubeyko.com
To: Fan Ni <nifan.cxl@gmail.com>
Cc: David Howells <dhowells@redhat.com>, ceph-devel@vger.kernel.org, 
	Slava.Dubeyko@ibm.com
Date: Tue, 18 Mar 2025 12:00:52 -0700
In-Reply-To: <Z9m7wY8dGAlq4z0K@debian>
References: <Z9m7wY8dGAlq4z0K@debian>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Fan,

+ CC David Howells <dhowells@redhat.com>
+ CC ceph-devel@vger.kernel.org

On Tue, 2025-03-18 at 11:30 -0700, Fan Ni wrote:
> Hi Viacheslav,
>=20
> This is Fan Ni. Recently I started to work on some mm work. One thing
> that I am working on is to reduce the use of &folio->page. When I
> check
> the fs/ceph code, I find some code that may be good candidate for the
> work to be done.
>=20
> I see you sent some patches to add ceph_submit_write(), since the
> change
> I am planning to do is closely related to it, so I reach out to you
> to
> see if you have some input for me.
>=20
> Based on my reading of the code, it seems ceph_wbc->pages[i] will
> always be the head page of the folio involved. I am thinking maybe we
> can
> keep folios instead of pages here, do you see any reason we should
> not
> use folios here and must be pages?
>=20

I believe we need to switch from pages to folios in CephFS code. But it
is painful modification. We need to be really careful in this.

As far as I know, David Howells is making significant modification
namely in this direction. I think you need to synchronize the
implementation activity with him. I'd love to be involved but,
currently, I am focused on fixing other issues in CephFS code. :)

Thanks,
Slava.


