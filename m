Return-Path: <ceph-devel+bounces-992-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C7D56886547
	for <lists+ceph-devel@lfdr.de>; Fri, 22 Mar 2024 03:52:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04D671C22F07
	for <lists+ceph-devel@lfdr.de>; Fri, 22 Mar 2024 02:52:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFFC93C17;
	Fri, 22 Mar 2024 02:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=profitsavvy.pl header.i=@profitsavvy.pl header.b="YdAf/Wtb"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail.profitsavvy.pl (mail.profitsavvy.pl [46.36.38.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827D279CC
	for <ceph-devel@vger.kernel.org>; Fri, 22 Mar 2024 02:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.36.38.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711075924; cv=none; b=PzN//7OXK1nzOw5gGJyxrZPx7i5TBSYsC00w4a3UEUJSyTV8OFBGo3Bdj3VYhEDf590JEUNN+b42TKZ1/zzyQVWBi4MJacJSXeBWtUBJTgEbkWVKqTYnL8/jaovF7d0W7mQ2BY3O1ZY12XHPfvtke1yb/FiktSnx0+LTdcFN8Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711075924; c=relaxed/simple;
	bh=hT1DBAeWi6ip4mLrTwBikUtRP2T6ijJjUg+RC7D4T2s=;
	h=Message-ID:Date:From:To:Subject:MIME-Version:Content-Type; b=QQ5TSBYp6OMELNBwm/zL2WgyB1gzTIo9X3/3ihcV6knXJfQ0JZwTQ+el7a9gfRz05Gseb4dEknTppK7ZMjQ+mQxi1lNpCHQtlzUHk6bIPpVBz+UZISruk+u9Nfn8cQ6RU+5lW9CzeYBgMcW1aXtZNshmU95dImB4PkjiJKRGLUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=profitsavvy.pl; spf=pass smtp.mailfrom=profitsavvy.pl; dkim=pass (2048-bit key) header.d=profitsavvy.pl header.i=@profitsavvy.pl header.b=YdAf/Wtb; arc=none smtp.client-ip=46.36.38.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=profitsavvy.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=profitsavvy.pl
Received: by mail.profitsavvy.pl (Postfix, from userid 1001)
	id 32A6522601; Thu, 21 Mar 2024 10:11:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=profitsavvy.pl;
	s=mail; t=1711012280;
	bh=hT1DBAeWi6ip4mLrTwBikUtRP2T6ijJjUg+RC7D4T2s=;
	h=Date:From:To:Subject:From;
	b=YdAf/WtbqJ5TtyzyDpAJoB6159DXORRSotmG4ArhxAjDVvH5GOaGyXybKBy/RH3op
	 d4atMqlU0A/+wSKYiCDQ8iEJdnVCLpCbL0hi+RQbpI5kRTHU570QREhsrKuznhr77P
	 O0zrTJzeiFdJbn5gje1BwuTEF2CfZDbF9dM8tQND4GCLHkRv+3OzXIs3hGILJwQR59
	 mhApyf0tvjyUFxCN10ayJgbk0fcYHnBCD9ay7rk9x498W28Sltj/bn4Lwf5OUJRlaH
	 P8DfZYJ0M25R8Z/GBcR+qNvLRO7q1pKTPFQSBusoFium8yEYuRtPaBu/GfA1/d29jO
	 MsFBgboUJ3F/A==
Received: by mail.profitsavvy.pl for <ceph-devel@vger.kernel.org>; Thu, 21 Mar 2024 09:11:16 GMT
Message-ID: <20240321084500-0.1.z.28iv.0.kb0643p6a0@profitsavvy.pl>
Date: Thu, 21 Mar 2024 09:11:16 GMT
From: "Marcin Socha" <marcin.socha@profitsavvy.pl>
To: <ceph-devel@vger.kernel.org>
Subject: =?UTF-8?Q?Sprz=C4=99t_poleasingowyKomputery_poleasingowe_na_sprzeda=C5=BC?=
X-Mailer: mail.profitsavvy.pl
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Szanowni Pa=C5=84stwo,

oferujemy poleasingowe sprz=C4=99ty komputerowe popularnych marek takich =
jak Dell, HP czy Lenovo.=20

Do wyboru mamy laptopy, komputery stacjonarne, monitory, stacje robocze. =
Mo=C5=BCemy odkupi=C4=87 od Pa=C5=84stwa dotychczasowe urz=C4=85dzenia, z=
apewni=C4=87 30-dniowy test nowych urz=C4=85dze=C5=84, serwis oraz r=C3=B3=
=C5=BCne formy finansowania.=20

Czy s=C4=85 Pa=C5=84stwo zainteresowani spersonalizowan=C4=85 ofert=C4=85=
?


Pozdrawiam
Marcin Socha

