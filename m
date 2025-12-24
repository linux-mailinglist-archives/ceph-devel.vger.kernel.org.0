Return-Path: <ceph-devel+bounces-4230-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D2E46CDD20B
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Dec 2025 23:51:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 622EF300E033
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Dec 2025 22:51:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45389239E80;
	Wed, 24 Dec 2025 22:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dreamsnake-net.20230601.gappssmtp.com header.i=@dreamsnake-net.20230601.gappssmtp.com header.b="GgeiUqXJ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC8E220F2D
	for <ceph-devel@vger.kernel.org>; Wed, 24 Dec 2025 22:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766616697; cv=none; b=pNIUXeSl4W8FMreWsedofZkjdFAtD431ff5N813EtUCYdnQF+neyXnlJf0wrQZyHPl6x4SRaP2+NaHe1jPG/8oEypGp8LAgWxRF+EyustIFjejCyBzvIlooZc8/R7QCbFHMFAipepv5ARSiJfvVmk4Yo04a5mnNZaZ/537zZWiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766616697; c=relaxed/simple;
	bh=ZRIFuHR1Yti86J8MoudJNAgjfKiGkfQVI37cfhbARsk=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:References:
	 Cc:In-Reply-To:To; b=u7eexEycJM5+BCUDuxQdwZEJ+qyxOrPeD6B8w3Cbs4XTtUEyppyfxlWoPyaqHMccmYjUKuRK2xHbhJqjE+8zu+lLk00VPqs5GmvURGhCmgDsuomBOztyHCTXUQYgMkU5iMYR55hvTyAaHKOX0f6ebxHw01OpEPD5U/8W0Ncj+5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dreamsnake.net; spf=none smtp.mailfrom=dreamsnake.net; dkim=pass (2048-bit key) header.d=dreamsnake-net.20230601.gappssmtp.com header.i=@dreamsnake-net.20230601.gappssmtp.com header.b=GgeiUqXJ; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dreamsnake.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=dreamsnake.net
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8ba3ffd54dbso876055985a.1
        for <ceph-devel@vger.kernel.org>; Wed, 24 Dec 2025 14:51:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dreamsnake-net.20230601.gappssmtp.com; s=20230601; t=1766616694; x=1767221494; darn=vger.kernel.org;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tgql7hRx3si7lMR/Q26Fta4dIKCQKD0CfZDQxJzStTA=;
        b=GgeiUqXJpiGtC6FNN4HAZXuJL/ob6qmZlXTay3hXPIOQ0JngIQbbDGXrB+aL7whqV5
         2zTjv6kySLxQ5QapY6nSbdRx0ESbTTsQ+lzXS0nXchiw9Yps93GiOh0cgrThVHTFMIW+
         KShUx2TRFShaEmXg4qHVYWnNDYya60loASKIU2s5H+6KIMEbfa+TmSHl1sKAHLnJssaC
         uIth6/TiVJiZ6glNr7qa4LfTMKnwN8uugsZsiqsJ24G0rGBv5cN8AvmEdAYFyq/w1u44
         gJfv/BFWHAH9ALVZrlW6cbY1cQHPe8XO1bLowN8LgETbMadwhh4KllnGdsWIk+0ieIFl
         QEkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766616694; x=1767221494;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Tgql7hRx3si7lMR/Q26Fta4dIKCQKD0CfZDQxJzStTA=;
        b=hXL+e1c3LP0LOa+ODX66Kkpro/vCwVX8xym6fE6zXfM0aTZkcL32UaQXKbHktRgY0p
         MhJJQnimOCZARMq92PuiaLnn+DKSIqITAUxtV5064jUrFH6khI3EE8NVmPywk+6fo6jX
         XrNCaeedl6UFmjqlge08/WQ87vud5zc/UqgOWA4KMYSQP4rwchrCPagmMLp5BmRuOaKT
         0RmRky6tPtPPxFgaCy1cGUjIuRcDACycookrMr6sQRW/5CQ6AkGvoZ9H38NozeJMqJ5e
         FbiCv1CFWepYu1ppb5eYYaNnHxkRNGTD+CsAIA2pKwk3Eq1J9AKGeZOcQuG1QcYLL9i5
         tK0A==
X-Forwarded-Encrypted: i=1; AJvYcCXRv7ottQDZfzNwfNh6Xm6Dxmok/CX7qZiFcbOLUEwoc0o+omptQTE+ff3bH0RHU/SQ98WnIjZzg+lX@vger.kernel.org
X-Gm-Message-State: AOJu0YwQNTiE/eb07gFDRjdsB3WpuIP26EEhyGlEQLPSorgGYvVFDZoz
	6Yt5xGx3VkbqZAgy+kZW7hlZF6wybuHTwUyFeqrspbqd+sKa34eEf7q6urBAmWU/L7O/TU1peFU
	1pA==
X-Gm-Gg: AY/fxX4uh80fHCIvG++qq5ttnzekIXrPk/hYqNK+NhMC2781LC4Tr8zD/TTylGfYCOv
	lsKw8Onmey3ap6yuAjcVy+CmsuqqYqh7donfpeehyQUzwIoLT1W5eIEHtAVdkn0zer6Y5NymiP5
	AOCicc5GRcy11jGsdT2KKITwJ6JbyoM0FJ/QjpAY2d/4xQvucavVkA2yt0+fYaL5so51RoDSjws
	dQHhjwlxIOidHEWM/ZUnVa/cDyojvc+9aCF6hlmACDyQvJJt+yw+6lfvK3Olp47Pd/Jsa/Dmuvq
	seKHiFejtjh5r6rK4NhR7/uIi9uKnxqPMi/4HKtc/0bo1C7oPjEOKaPcQ7Wzu01Qwbh9Hxplype
	/DpTNbaXcQvwaOJ8OWpemj5g4npHoctnHGrrxsGf5mlNyeaGvgJpgeAm7SfTReF8IhV2mz6C6yv
	i31DFnU1n79cPiL3TYI/9Mez6B8H5RTy2u1h47LSM=
X-Google-Smtp-Source: AGHT+IFhWK3Aj1EQZNC8+uLwWUvNxXJiRS1PdY/bpWpllE+8NFJ5RNK06aj8FVNSDci48WiUbGJebw==
X-Received: by 2002:a05:620a:472c:b0:8b2:edf1:7c4a with SMTP id af79cd13be357-8c08f682c7amr2918230885a.39.1766616693788;
        Wed, 24 Dec 2025 14:51:33 -0800 (PST)
Received: from smtpclient.apple ([2600:382:8505:33a2:e0ce:aa29:7469:9565])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c0973edecdsm1422517485a.37.2025.12.24.14.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Dec 2025 14:51:33 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Anthony D'Atri <aad@dreamsnake.net>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] ceph: add support for multi-stream SSDs(such as FDP SSDs)
Date: Wed, 24 Dec 2025 17:51:22 -0500
Message-Id: <F9170EA4-B6F9-4CED-853D-EB1B15D73583@dreamsnake.net>
References: <14583623641f27955592ae17dfcd88c0418ac289.camel@dubeyko.com>
Cc: Qian Li <qian01.li@samsung.com>, idryomov@gmail.com, xiubli@redhat.com,
 ceph-devel@vger.kernel.org
In-Reply-To: <14583623641f27955592ae17dfcd88c0418ac289.camel@dubeyko.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
X-Mailer: iPhone Mail (23B85)


>=20
> As far as I know, FDP SSD itself cannot recognize data lifetime. This devi=
ce is stupid enough. It needs to receive the hints from application or file s=
ystem to distribute data in different streams based on "temperature" hints.

That=E2=80=99s the idea! QLC and eventually PLC SSDs have inherently low end=
urance so novel methods are advantageous to make the best use of the availab=
le PE cycles. =20

>=20
>> It
>> provides multiple streams to isolate different data lifetimes.
>> Write_hint support in fs and block layers has been available since
>> commit 449813515d3e ("block, fs: restore per-bio/request
>> data lifetime field").
>> This patch enables the Ceph kernel client to support
>> the data lifetime field and to transmit the write_hint
>> to the Ceph server over the network. By adding the write_hint to
>> Ceph and passing it to the device, we achieve lower write
>> amplification and better performance.
>=20
> What is your prove that you can achieve lower write
> amplification and better performance? Do you have any benchmark
> results?

My read is that this is enablement for emerging devices, and that benching a=
nd code refinement will follow as devices become available to mortals. =20

> . If it is small file(s), then one object
> could receive multiple files with various temperature hints.

I think RADOS doesn=E2=80=99t work that way.  In fact this code aims to achi=
eve the opposite.  By grouping data with similar projected modification / de=
letion / TRIM timeframes, the firmware can reorder, buffer, and coalesce ope=
rations. A NAND page grouping a dozen small RADOS objects that get modified w=
ith a single PE cycle is favorable compared to distributing them around a do=
zen NAND pages and a dozen PE cycles.  That=E2=80=99s a substantial reductio=
n in write amp, especially for a coarse IU, which in turn enables the cost a=
nd capacity advantages of even larger IUs. =20

> . Also, replication and redistribution algorithms
> can move and shift data among OSDs that complicates data distribution a lo=
t.

This code would seem to work within a given OSD, so my sense is that rebalan=
cing is moot. =20

> then OSD will have a complete mess of these hints for objects.

That=E2=80=99s the idea! So that hot, warm, tepid, and cold data are grouped=
 together, This will reduce the dynamic of RMW cycles for short-lived data d=
ragging along longer-lived data.  Longer-lived data will experience few or n=
o superfluous RMW / PE cycles.  This is somewhat akin to ensuring partition a=
lignment.

FDP / NDP SSDs will tend to be large SKUs with coarse IU.  Coarse IU improve=
s the component economics by provisioning < 1GiB of FTL DRAM per TiB of NAND=
, otherwise the limited performance and endurance of QLC and PLC devices is h=
arder to justify with a slimmer cost advantage.  A coarse IU also enables fi=
tting all the dies into the form factor.  Consider a putative 500 TB-class d=
evice, think you can fit 500 GB of DRAM with the NAND into E3.S or even U.2?=



> Also, object is a big piece of data (around 4MB)

RADOS objects by default are *at most* 4MiB.  Depending on the usage modalit=
y and write patterns, they can be rather smaller, especially with the Fast E=
C code that avoids padding. =20

> and, as a result, if you write it sequentially

Who is =E2=80=9Cyou=E2=80=9D? Via the IO blender effect, OSDs in almost all c=
ases see a random write workload. =20

> Secondly, as far as I can see, people
> could use HDDs for Ceph clusters.

Sure, if they don=E2=80=99t mind paying for 10-20 times the DC space and suf=
fering burgeoning seek and rotational latencies.  Not to mention crossing yo=
ur fingers for two months while the cluster slowly, painfully recovers from t=
he loss of an OSD. =20


> And it means that FDP will be completely useless in such case.

I don=E2=80=99t follow, this seems like a non sequitur. =20

> Otherwise, this patch is completely useless.

Please be civil. I don=E2=80=99t understand the pharmacokinetics of GLP-1 ag=
onists or tamulosin but both are rather useful.  =20




