Return-Path: <ceph-devel+bounces-3835-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ECE8BBD1E7A
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Oct 2025 10:02:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 948BA3A7F46
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Oct 2025 08:01:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39D4923771E;
	Mon, 13 Oct 2025 08:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brandexo.pl header.i=@brandexo.pl header.b="UQweOqg2"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail.brandexo.pl (mail.brandexo.pl [37.187.49.236])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52DA34BA46
	for <ceph-devel@vger.kernel.org>; Mon, 13 Oct 2025 08:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.187.49.236
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760342516; cv=none; b=of9YNhTX0yQnAhMV9EaknsOMZRzuXr5dnhA4FK3a8Q6+i/nWYe/9F6kDi+Elm2GBdhV4JfH0+FW1wQG/+0KxnG+mJC8yWXMcT93dPy388os/p8L04e1NDTEeqcrgY27U/Q1KraBeGj2htVHyPJbZ2xav0xlPtrCvl1Tiu/9vxN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760342516; c=relaxed/simple;
	bh=S/mo7cY/2HBN4T3ecXqH6roQE4hmBOwO60AKp4leie8=;
	h=Message-ID:Date:From:To:Subject:MIME-Version:Content-Type; b=TAduY6t/4+0DCGJzVN4UtB3TUT6gp4oGnBixsHtO4nd9gIeuEpgdyJunQqbiiwD6WUwKsBWydLQ/+T4SKU8VUZIW+RIXCN8NNIHREXOmOXtmHvZXFzreYXTcXgnDU+OXbLGTQcP5XVby2PySuaxK/5PBP+rbW3DAF5453MhH1wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=brandexo.pl; spf=pass smtp.mailfrom=brandexo.pl; dkim=pass (2048-bit key) header.d=brandexo.pl header.i=@brandexo.pl header.b=UQweOqg2; arc=none smtp.client-ip=37.187.49.236
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=brandexo.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=brandexo.pl
Received: by mail.brandexo.pl (Postfix, from userid 1002)
	id 30F21257B7; Mon, 13 Oct 2025 10:00:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=brandexo.pl; s=mail;
	t=1760342461; bh=S/mo7cY/2HBN4T3ecXqH6roQE4hmBOwO60AKp4leie8=;
	h=Date:From:To:Subject:From;
	b=UQweOqg2bdYzDoaZItcfTMVbLCxIFyfkAYtos2dUwmKeOfNp2zF1MWH2lAgM9/7ds
	 9fXOvlDq1vD9Hf/FA3k93p946W/VmgwOknK51i1L6Hn9RwjhbChCyhxc2g7zWV834N
	 2G1W95CpyPT4TUorOVhkQOwSZ8W2ARMWh9r1fOTqK6bQaMyvxVfOGIELWv/bInj48a
	 QBTh8OlxAS2bA7RmO3o5yp13bjgaeNlMirnrSZL/7Q/5E36jy0eEoZfnlgcm396pGI
	 k1iJWylKGn3RuLeoTpQhyi6BZi1uvfXjzKIimj9ksTfE5B5Px06YdNeuoJLgXRkgf2
	 PO4Vv0pGwzOdQ==
Received: by mail.brandexo.pl for <ceph-devel@vger.kernel.org>; Mon, 13 Oct 2025 08:00:36 GMT
Message-ID: <20251013084500-0.1.jx.2b2yw.0.3dxgjwc6mt@brandexo.pl>
Date: Mon, 13 Oct 2025 08:00:36 GMT
From: "Adam Robaczewski" <adam.robaczewski@brandexo.pl>
To: <ceph-devel@vger.kernel.org>
Subject: vPPA dla firm
X-Mailer: mail.brandexo.pl
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dzie=C5=84 dobry,

widz=C4=99, =C5=BCe Pa=C5=84stwa firma nale=C5=BCy do grupy przedsi=C4=99=
biorstw o znacznym zu=C5=BCyciu energii.=20

Zajmujemy si=C4=99 wirtualnymi umowami zakupu energii (VPPA), kt=C3=B3re =
mog=C4=85 by=C4=87 interesuj=C4=85c=C4=85 opcj=C4=85 dla firm z rocznym z=
u=C5=BCyciem 3-30 GWh.=20

To rozwi=C4=85zanie pozwala na d=C5=82ugoterminowe zabezpieczenie koszt=C3=
=B3w energii (5-7 lat) przy jednoczesnym wsparciu w raportowaniu ESG.

Je=C5=9Bli temat mo=C5=BCe by=C4=87 dla Pa=C5=84stwa interesuj=C4=85cy, j=
estem do dyspozycji na rozmow=C4=99 o mo=C5=BCliwo=C5=9Bciach dopasowania=
 takiego rozwi=C4=85zania do Pa=C5=84stwa specyfiki.

Czy s=C4=85 Pa=C5=84stwo zainteresowani?


Z wyrazami szacunku.
Adam Robaczewski

