Return-Path: <ceph-devel+bounces-1708-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ED1895964C
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Aug 2024 10:09:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E2518B20A0F
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Aug 2024 08:09:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 634621A4B7E;
	Wed, 21 Aug 2024 07:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ImagineSphere.pl header.i=@ImagineSphere.pl header.b="KWOLj7GX"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail.ImagineSphere.pl (mail.imaginesphere.pl [92.222.170.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22ADA1A4B65
	for <ceph-devel@vger.kernel.org>; Wed, 21 Aug 2024 07:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=92.222.170.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724226256; cv=none; b=pHZIMfeKRyK0xGg8hvEduEZytEf+F4sF3xspTsCgChdvvTFyktPzuSrgCZFsOjM7Wnhennh2cEiDAbKDfN35PQ5aMjUVkNIOOMAMuHNGWsxkOTZQ15fZnKQHf8l+wW4lPAp5UCz92krdLSlEx33HDGqNW22XJ0dwHSDs+RkZHXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724226256; c=relaxed/simple;
	bh=00Q5NAIur15eovFIjFWhgwqj8foRqzD4UBvU0TfwGUU=;
	h=Message-ID:Date:From:To:Subject:MIME-Version:Content-Type; b=JMaQlGf2G9F5eJdqTLxtTwAqxVtrwIcLKm9kfTtezYz/xrOBIP3kdLCQwi76LDAmnf1vHT2NBp9yy34/sg3E9gfWS/sPjKaKpvtRuKYEbOl/j+mMS3BgKRdWfoEd59ti1fO4l66Enz2/MwQMFP3wSZx912Oj/eqYv1G1T+yZILM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=imaginesphere.pl; spf=pass smtp.mailfrom=imaginesphere.pl; dkim=pass (2048-bit key) header.d=ImagineSphere.pl header.i=@ImagineSphere.pl header.b=KWOLj7GX; arc=none smtp.client-ip=92.222.170.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=imaginesphere.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=imaginesphere.pl
Received: by mail.ImagineSphere.pl (Postfix, from userid 1002)
	id A36D825384; Wed, 21 Aug 2024 09:36:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ImagineSphere.pl;
	s=mail; t=1724225817;
	bh=00Q5NAIur15eovFIjFWhgwqj8foRqzD4UBvU0TfwGUU=;
	h=Date:From:To:Subject:From;
	b=KWOLj7GX1v/X/vdW2iuCDRowVhKBAcc6iao6OjXOhGKFQT49sEHfPe0Cu1xwoTi5l
	 UP71RoLvplnMo+oByvbvxFmkrywLfiqRsvVkv+AWn7wXypgBGkElkH8//vnuaLLXeN
	 eySDAg2acmV4hGeYkOvgmLSl2GExm2GrE6x8k4qhdyaSnsm6wED+rIsPjtIG0IE29L
	 FMOPJhuo0tkZ0U+z1RWrgwVc8VQOuJTVgHv52UqrK/d5ZW7RZR0XcaJO9IU++U7Ysv
	 kEZuzX07Kg2FK2FWtvnyLPZSl67vspcYxcQuqp/MhWpIgDR1x7fkxdzD89sWsIbI1I
	 zUhnz0bxyuVzQ==
Received: by mail.ImagineSphere.pl for <ceph-devel@vger.kernel.org>; Wed, 21 Aug 2024 07:35:38 GMT
Message-ID: <20240821084500-0.1.ay.15b2f.0.dp9m3q2s4l@ImagineSphere.pl>
Date: Wed, 21 Aug 2024 07:35:38 GMT
From: "Szymon Jankowski" <szymon.jankowski@imaginesphere.pl>
To: <ceph-devel@vger.kernel.org>
Subject: Potwierdzenie przelewu
X-Mailer: mail.ImagineSphere.pl
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Witam,

Pomagamy pozyskiwa=C4=87 nowych klient=C3=B3w B2B.

Czy interesuje Pa=C5=84stwa dotarcie do nowych potencjalnych partner=C3=B3=
w oraz uruchomienie z nimi rozm=C3=B3w handlowch ?


Pozdrawiam
Szymon Jankowski

