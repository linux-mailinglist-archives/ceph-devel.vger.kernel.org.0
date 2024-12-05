Return-Path: <ceph-devel+bounces-2255-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 46FC89E5632
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Dec 2024 14:08:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0242D28453A
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Dec 2024 13:08:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CA6A218828;
	Thu,  5 Dec 2024 13:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="J67fzyO2"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE6B17BD6
	for <ceph-devel@vger.kernel.org>; Thu,  5 Dec 2024 13:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733404115; cv=none; b=VbixezJ5dvyMjAOt+ddiXQfNsXsjoCwqHKGI9g2afmRLdrbqjfMDeidC3C1DY5OX1n1VmYrnzpw/nui+9/On9+rN9iqsZ1LeLVGN2OT8bdNxGTJwMIJjcuNRkhKDXesQ2crk+Dd47ZlDro+qco2ZQudcWuLoYh4dSPWLUx584yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733404115; c=relaxed/simple;
	bh=IO0mF8LdCGrgJfdas7Lv4J34R38TAYeyhCtnEGgvQB4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=koWKDIzYbR+c7/5ETXgm1hhWB7GOJnIEuHSwK6rS/VFM5arA7NwBF8EYunmwALvU8Tw6YbHwkvmYYir8ZuFw4IQ4us8z9pw79yh70J7hCca794QRb26sujwifm5eAmTtaiBN7dWtvwCom+MsvYiZPiTisu7srrvPXZ/4srPWISw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=J67fzyO2; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5d3ab136815so111712a12.1
        for <ceph-devel@vger.kernel.org>; Thu, 05 Dec 2024 05:08:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1733404111; x=1734008911; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IO0mF8LdCGrgJfdas7Lv4J34R38TAYeyhCtnEGgvQB4=;
        b=J67fzyO2pzl+bw34BrVFOXnUH5sW2qKsviO2bEw08qx/AT21n53ZvZsQIZ3eRSjTS7
         k0bsTf1ex7HY+ASEQ2MKvvjoyiF/FiXKrFGpw5dDMWDFj0IuH3eKtjZZWP9XdPxV7nse
         Dts5mHfMji/IQoaIlrME7J/cUeWtG0ohGkkzhPvhg3AeY2vcYDZ5OJbeoqe71US4LeFf
         IHUrq27dGIo+4uu7rFScKZJtS9bHL/6HiP5cJ+5FSHOqTwdF1TV5wBezI/WFXmCep4Dc
         rNoFPTtOl6XKe4Rwt7H5GW/xnmaHHuaT1y7F0h7huec1OxEpL47sNkaQniTtVRjSS5v1
         e5tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733404111; x=1734008911;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IO0mF8LdCGrgJfdas7Lv4J34R38TAYeyhCtnEGgvQB4=;
        b=WQC+t2Kk5qm7O9tRxGPd12s9LxquWL7rGZTHknMG/M9wuhRbaTg1LadsAv/QiIpPWm
         eg2ER0gPMfJUxFiwXizgInAgtzPNz5HiHiqlK06z0I4IFcT+HMidpis5R5j/D6cNfWoU
         5VAUnp9SrPjkbo0jiH+0iVI2vXzgZO7sgdCOn+lRzLddnd2BrZ06sR/O6fIPFkjftHxR
         DBEnmcFY/4CwHEkQ9uP7UPMOomUSe8zeY3R3187phDGBFMY0XL4oBXfcuEU8BrRMT14c
         fA+2RcTrROduTmJMmCdPIlFYdoIfoX469Bcf+/bpNljnhjW5Yrvwl5cqICY1PiaaZJbh
         q5LQ==
X-Forwarded-Encrypted: i=1; AJvYcCVpJFPFoyQriodKJMPCtP/L2YmpKiwstAZzYOFCu7XXbk4EFV/ObObRNCsU+5n8HzWHyLrdwmpVFNrh@vger.kernel.org
X-Gm-Message-State: AOJu0YzzQHR0ggQq8YDoT8X6nx/NxX1Vm36ZDBLw1spaTua42DC8eXRK
	oA67c7kQjlfHB6nw4zkrSaP0dXzp7+0x64GgLD+pyYJQfeOODx3qqMP0M185qg8Hm7+OrVp872U
	03vPV647j3iqSXobB7kY0/ixPkQBdWdM1eHF4ow==
X-Gm-Gg: ASbGnctpAxAbfYOxiT3VakyT5Wl41utJMdEqMMo21pOOBufvhL+HmRMpq6dakBEwp0p
	CgDmUTxv+iX+wRXGU3b+Qyov5dTk3vLBLCH63sFivQzBAX+qxjYnYbnofdcIw
X-Google-Smtp-Source: AGHT+IE1i1dEiJ2JW6fMhsX8wvc4Wu6L3IBg3/PLCFzr4x6EdP9ApTo3j+43t9I+0jdn4XnELEH0WmNmNZQ3Bazp8Wk=
X-Received: by 2002:a05:6402:26ce:b0:5d2:7270:6124 with SMTP id
 4fb4d7f45d1cf-5d272706652mr1423533a12.23.1733404111185; Thu, 05 Dec 2024
 05:08:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241127212027.2704515-1-max.kellermann@ionos.com>
 <CAO8a2SiS16QFJ0mDtAW0ieuy9Nh6RjnP7-39q0oZKsVwNL=kRQ@mail.gmail.com>
 <CAKPOu+8qjHsPFFkVGu+V-ew7jQFNVz8G83Vj-11iB_Q9Z+YB5Q@mail.gmail.com>
 <CAKPOu+-rrmGWGzTKZ9i671tHuu0GgaCQTJjP5WPc7LOFhDSNZg@mail.gmail.com>
 <CAOi1vP-SSyTtLJ1_YVCxQeesY35TPxud8T=Wiw8Fk7QWEpu7jw@mail.gmail.com>
 <CAO8a2SiTOJkNs2y5C7fEkkGyYRmqjzUKMcnTEYXGU350U2fPzQ@mail.gmail.com>
 <CAKPOu+98G8YSBP8Nsj9WG3f5+HhVFE4Z5bTcgKrtTjrEwYtWRw@mail.gmail.com>
 <CAKPOu+9K314xvSn0TbY-L0oJ3CviVo=K2-=yxGPTUNEcBh3mbQ@mail.gmail.com> <CAO8a2Sgjw4AuhEDT8_0w--gFOqTLT2ajTLwozwC+b5_Hm=478w@mail.gmail.com>
In-Reply-To: <CAO8a2Sgjw4AuhEDT8_0w--gFOqTLT2ajTLwozwC+b5_Hm=478w@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Thu, 5 Dec 2024 14:08:20 +0100
Message-ID: <CAKPOu+-UaSsfdmJhTMEiudCWkDf8KU7pQz0rt1eNfeqS2ERvZw@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/file: fix memory leaks in __ceph_sync_read()
To: Alex Markuze <amarkuze@redhat.com>
Cc: Ilya Dryomov <idryomov@gmail.com>, xiubli@redhat.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 5, 2024 at 1:57=E2=80=AFPM Alex Markuze <amarkuze@redhat.com> w=
rote:
>
> I will explain the process for ceph client patches. It's important to
> note: The process itself and part of the automation is still evolving
> and so many things have to be done manually.

None of this answers any of my questions on your negative review comments.

> I will break it up into three separate patches, as it addresses three
> different issues.

... one of which will be my patch.

