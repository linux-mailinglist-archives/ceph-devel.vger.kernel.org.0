Return-Path: <ceph-devel+bounces-1996-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B29439BC8FB
	for <lists+ceph-devel@lfdr.de>; Tue,  5 Nov 2024 10:22:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7738A284CA3
	for <lists+ceph-devel@lfdr.de>; Tue,  5 Nov 2024 09:22:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 573C02C1A2;
	Tue,  5 Nov 2024 09:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wMVgSm9n"
X-Original-To: ceph-devel@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CB61D097C
	for <ceph-devel@vger.kernel.org>; Tue,  5 Nov 2024 09:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730798533; cv=none; b=JjWsj1KKrSJbPOaarJK44U0jZPz2+sqS8Z1FG71enoEr45uRykVQc8QttVr0Z7JEZqGylQ4H86cnVZofeH4fgyEPNORsI8zFx8d+iX307+OzxNm51bPsOMUqzqydW592jHBcu0H/wfX037gyH53FtlWBGWHWpPbRW+AZLirec7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730798533; c=relaxed/simple;
	bh=tjNVMshXh2gb89FFAVDymsjCcxJxZnkanUXR0DUr/qs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=qj0qoRIb/g7oueCeI3GM6HIw62tD9RujRSk5p1kAouBeXZj8nUcXqSk/KW7Pa25ZQB2CmKZdx+R3rDgarfuNnNmjE9M5Cc0rdSeyXYYCSEaZaJtA9Jg1hqto6cXQLQq7mTq3vnYVukFCdWaYGgiRWthXEagzG3QqeANZDqnjTIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wMVgSm9n; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730798528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AZh/Y0fFxRz/wI9/tGc9h76ard39RP4G999/9/xZs8A=;
	b=wMVgSm9nkXY0mu9mdmrbRh5TwMsar/1JvFi+dwag0yZ82ZlFC9ADF0nT7u8+xEf4pvymGC
	eaybi+lH7p2aACtoZmljMNPKret4LxBpUD+jQ/0IUDBk/WLXJvF/AFvG5d0jiUZlK9Dz09
	ROnb6yffBKbm35g+4C+HMAVlYiJCdDw=
From: Luis Henriques <luis.henriques@linux.dev>
To: Xiubo Li <xiubli@redhat.com>
Cc: Luis Henriques <luis.henriques@linux.dev>,  alex.markuze@ibm.com,  Ilya
 Dryomov <idryomov@gmail.com>,  ceph-devel@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2] ceph: ceph: fix out-of-bound array access when
 doing a file read
In-Reply-To: <7fffefc1-370d-4f04-979f-caeede1e9c0f@redhat.com> (Xiubo Li's
	message of "Tue, 5 Nov 2024 09:10:25 +0800")
References: <20240905135700.16394-1-luis.henriques@linux.dev>
	<e1c50195-07a9-4634-be01-71f4567daa54@redhat.com>
	<87plphm32k.fsf@linux.dev>
	<bb7c03b3-f922-4146-8644-bd9889e1bf86@redhat.com>
	<87ldz9ma5b.fsf@linux.dev> <878qtzcbjh.fsf@camandro.org>
	<7fffefc1-370d-4f04-979f-caeede1e9c0f@redhat.com>
Date: Tue, 05 Nov 2024 09:21:59 +0000
Message-ID: <87y11yavd4.fsf@camandro.org>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

Hi Xiubo!

On Tue, Nov 05 2024, Xiubo Li wrote:

> CC Alex
>
> Hi Luis,
>
> Alex will take over it and help push it recently. I am a bit busy with my=
 new
> things these days.

Thanks a lot.  I think the difficult bit to understand (for me, at least!)
are any MDS side-effects, as you earlier mentioned the filelocking
semantics.  I'm not sure if/how this patch may cause troubles there.

> BTW, if possible please join 'ceph' workspace's #cephfs slack channel and=
 you
> could push it faster there ?

I believe that channel is bridged to IRC (OFTC network), where I'm already
lurking (nick 'henrix').  And I see you have already ping'ed others there.
However, I'm currently on PTO, so my replies there may be asynchronous :-)

Cheers,
--=20
Lu=C3=ADs

>
> Thanks
>
> - Xiubo
>
>
> =E5=9C=A8 2024/11/4 22:34, Luis Henriques =E5=86=99=E9=81=93:
>> Hi Xiubo, Hi Ilya,
>>
>> On Mon, Sep 30 2024, Luis Henriques wrote:
>> [...]
>>> Hi Xiubo,
>>>
>>> I know you've been busy, but I was wondering if you (or someone else) h=
ad
>>> a chance to have a look at this.  It's pretty easy to reproduce, and it
>>> has been seen in production.  Any chances of getting some more feedback=
 on
>>> this fix?
>> It has been a while since I first reported this issue.  Taking the risk =
of
>> being "that annoying guy", I'd like to ping you again on this.  I've
>> managed to reproduce the issue very easily, and it's also being triggered
>> very frequently in production.  Any news?
>>
>> Cheers,

