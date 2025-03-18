Return-Path: <ceph-devel+bounces-2967-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8213FA680D0
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Mar 2025 00:39:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF90918901E6
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Mar 2025 23:39:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCF1E2080CD;
	Tue, 18 Mar 2025 23:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="hC5HbG5N"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E1520765F
	for <ceph-devel@vger.kernel.org>; Tue, 18 Mar 2025 23:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742341154; cv=none; b=BbbGh+FbOncIT/swtlMQJMJzTPzqbeEjiZM5ejuulGMGS1QqCHwux0lCfYEqQDuvViVWCutPxY71TNWa7+01PndGxlOn8PD3fxcJ4CcZl8EfT9NVCwNx5O+w7Z2KUsSRvFaXaeLv7ijd6krCyeAx4UmknKYD0UY2GWhKwwguaAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742341154; c=relaxed/simple;
	bh=dO6MdN6crxgKvoKISLjpEhatVL+JmkFEsG9Q13u6B/c=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OMfzDC8S1RLj7xaOTIghMOAVrmqY1AKpnfIQWq37f7sj3iPS+obIVWdOFohU9DYkL1skKivUL8FrzflwmUqrKQQrNH8Pxfmj96eP/NmDb/IlUHX/hhr5kX+N/crwcts3PbJmosKd0tBFaZG1otc6oqWZjARUjomNP/1k0M/lvgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=hC5HbG5N; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-601e3f2cee1so2274343eaf.2
        for <ceph-devel@vger.kernel.org>; Tue, 18 Mar 2025 16:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1742341151; x=1742945951; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dO6MdN6crxgKvoKISLjpEhatVL+JmkFEsG9Q13u6B/c=;
        b=hC5HbG5NuVX0acRdo7BuDYSL+fTdviiYRmRLrmEnw+stO8iLosFOQksNUQkw8zHdwh
         cbP///AcKoqxAJJG43N7MXuzMACuEOektJYPbjxr0bnSJFArNRrtrzLfleLEppYVSuxH
         grrkGoD216qyOa6pGmhsVLILgrvee50SuigLgId3OIpMBFGrKD9kpC96yTGqhEhHTUc2
         G1sdjgLZVP7WVQAfhlH0nhdlqzACAlH//1vQCMbRbT4A9hXXtnTe2VrT50YfRL5/uFpZ
         scJYVNXmY2aQWFQsUNeE4fUtRXMW8p4Ps1FGzBbrO7e7rgt5DU15xE6TTPg1+WybOoGt
         jpOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742341151; x=1742945951;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dO6MdN6crxgKvoKISLjpEhatVL+JmkFEsG9Q13u6B/c=;
        b=Rg0aEcBw6PKf/TyB+OGlVmQnAXgpNarCw2JKWIci4lNDmb3Rorza2v5NxGNRWbxCP2
         vXOVTJmpR/4GY6PMinWTYZHm2F5LmgvEr59c7oGwb+eYesGcGKRcOopINEtsmK8mpRdw
         IM+TiJt3wNT7zJEklyI8mkSrE9nvRw8W9Zf5lTfYd42Nwe/KhIXAIHKP0GUUDkywzUAy
         aOVoRSiqIwM1O6gPqKNHoTN21p1+Ga0Aq9eS03y4mS+QuJPVIq2A17wQpr4mInZI5iVC
         5zjnGQx0tSKDb1z1r/oMjuGCHUcID+DNxx2xtr8LC80/SmKb3YAud41NwPIzEEb1wsRM
         nsjQ==
X-Gm-Message-State: AOJu0YyKUamx7J0WbQAJm76IKCDSNwDeZOfFs9jykEPI1YTzXJz/qV/q
	ulJQLaCp4ZHpyuNNHQL8XiXxlsKwm+q/ate29z9u7K+W6IShZTWveCPuTNnKy9w=
X-Gm-Gg: ASbGncvMejSWGU1PhVmceLHosXzUig6oPzGGtg0cYU8CSYujCMD/8vS2saCxPQbF4uf
	qf/P56UER7yUxnvQTGz7rcL2+gDjli3qEEeUW9LtuGdNEy97Z3jwme9Sehp79z4meN9SrBhB7yG
	InxmrVYHjMrMQ7ZqwWWX1edz300gaRLR5JWa5lL4z0DjsZ4SOuQqRFk78km8YEhGgJBdtc+oa7b
	bBu5Pk8IG3EXas0UZrCf/jp7jaVNitNk6bsPONePxFRChWQy3Q9MMnOpxsP75uhaYXhNREfqW+e
	E1MQj/txipXcO11iqQR8GMujO/St1Mg8Aa+k1J4kGwEVB7+pS8EihX91QunFg0utoq6V2e8Iq7S
	2t2/FZJEoeGdTktoL43Scox82taI=
X-Google-Smtp-Source: AGHT+IF0YHnyCkJLb241Yxe/MxQpg8KG8VU/7KhqVuRVJLn5hfWR6sGrsm/4d03hf4z2pClv+8HJKg==
X-Received: by 2002:a05:6820:4617:b0:600:1feb:830f with SMTP id 006d021491bc7-6021e42bdc2mr329430eaf.4.1742341151367;
        Tue, 18 Mar 2025 16:39:11 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:7a51:a450:8c55:68d0? ([2600:1700:6476:1430:7a51:a450:8c55:68d0])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-601db5394e7sm2226401eaf.0.2025.03.18.16.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Mar 2025 16:39:10 -0700 (PDT)
Message-ID: <b5775ab98324c9030456acf18986352e554db203.camel@dubeyko.com>
Subject: Re: Question about code in fs/ceph/addr.c
From: slava@dubeyko.com
To: Fan Ni <nifan.cxl@gmail.com>, David Howells <dhowells@redhat.com>
Cc: ceph-devel@vger.kernel.org, Slava.Dubeyko@ibm.com
Date: Tue, 18 Mar 2025 16:39:09 -0700
In-Reply-To: <Z9oA3xSwEQgWzZ83@debian>
References: <Z9nFlkVcXIII8Zdi@debian> <Z9m7wY8dGAlq4z0K@debian>
	 <80300ccacebc13ee67100fe256b03f08dfd2819e.camel@dubeyko.com>
	 <2681465.1742337725@warthog.procyon.org.uk> <Z9oA3xSwEQgWzZ83@debian>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-03-18 at 16:25 -0700, Fan Ni wrote:
> On Tue, Mar 18, 2025 at 10:42:05PM +0000, David Howells wrote:
> > Hi Fan,
> >=20
> > My aim is to get rid of all page/folio handling from the main part
> > of the
> > filesystem entirely and use netfslib instead.=C2=A0 See:
> >=20
> > =09
> > https://lore.kernel.org/linux-fsdevel/20250313233341.1675324-1-dho
> > wells@redhat.com/T/#u
> >=20
> > Now, this is a work in progress, but I think I have a decent shot
> > at having it
> > ready for the next merge window after the one that should open in
> > about a
> > week.
> >=20
> > Note that there, struct ceph_snap_context is built around a
> > netfs_group struct
> > and attachment to folios is handled by netfslib as much as
> > possible.
> >=20
> > My patches can be obtained here:
> >=20
> > =09
> > https://web.git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-
> > fs.git/log/?h=3Dceph-iter
> >=20
> > David
> >=20
> Hi David,
>=20
> Thanks for your information.=20
> That is very useful information to me, since I am still slowly ramp-
> up mm work and lack
> of the whole picture of mm development work.=20
>=20
> Just to make it more clear to me, so that means all &folio->page and
> like
> will be taken care of with your patches for fs/, right? If so, I will
> skip fs
> and try to work on other sub-system.
>=20

As far as I can see, we still have a lot of work in fs/ and CephFS code
for switching from page to folio. :) So, you are really welcome to
contribute.

Thanks,
Slava.


