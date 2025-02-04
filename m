Return-Path: <ceph-devel+bounces-2629-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D307A26CEC
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Feb 2025 08:57:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E46B518844C6
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Feb 2025 07:57:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0F4F2063FC;
	Tue,  4 Feb 2025 07:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="VS8cyP0Z"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3887205E3B;
	Tue,  4 Feb 2025 07:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738655818; cv=none; b=U9a9qdA+Zn2bh9PLOulLd2N9HZebRCsYnShKRXk6hHpZnEJJzFw6QpC8OMKX6pODmSIYxPin3X0tX0hEmuBLHWM77xCD1LJj9dQfCwgCA4VvDXnnopbKqzBoOt7wZRiOeWvdavmBWIAzSuj46maExgUVpgpU19wIFs0p7gyYBYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738655818; c=relaxed/simple;
	bh=nPkr2UB70awK3XWuSVG0b1Id4751pK/Rp5g+eClX9/w=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=I1kMp8J94VnbBu0GlxeOaQNN0pFK69EBQKIRd86Bh3Bv6Fe783q9AelLITXYq80kBqRKx8SGqXbuBWzJjZb5lh/Ftg4pnCq2wbIZnW3RY5hRmhG5XTq9BroF36hcyCohFzxkr64OxewXY81bx4BJFhSuUWUC21qC5BQ5UN2/qA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=VS8cyP0Z; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1738655788; x=1739260588; i=markus.elfring@web.de;
	bh=5BLD/YXsVrr465Xy+2dikLtLlRq1lKGR/pqrjopbAvs=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:Cc:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=VS8cyP0ZtaRn7Ltz9iSNzbc76UnXwmi60vJYLu8Iy+3H3yXtujIJZE1a95aAR/yP
	 9gsXJHhR1kXb+oB50IqSm71wuDH7Gh4FkhbNCZMXOOIp5x+1g/5qEr0wTNxdsUl74
	 5yzQGy2xw2WzWV2vxTR7T3l0jeqiewAAGzJ4YzHixUN0Ul4S7TQx3pFLRcYc48hEQ
	 QEKn85Ohbf3TWuKrMLbaUn8dEk6FHNiFoJy3yB93T6EOdKHKwvsriKxxK7iaWgp0V
	 Xi7htv5fhs4/xei0Zq700SN2DT/NBFm5W+W8fmuUnAt2tckUyOoqrnYBJgiZc4jxA
	 q+ff2Yla7sU0vsHpAg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.93.16]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MdO9K-1t5t2h442K-00gdth; Tue, 04
 Feb 2025 08:56:28 +0100
Message-ID: <49533960-e437-4042-951a-0221164bfa3d@web.de>
Date: Tue, 4 Feb 2025 08:56:06 +0100
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [cocci] [PATCH v2 1/3] coccinelle: misc: secs_to_jiffies: Patch
 expressions too
To: Easwar Hariharan <eahariha@linux.microsoft.com>, cocci@inria.fr,
 Andrew Morton <akpm@linux-foundation.org>,
 Dongsheng Yang <dongsheng.yang@easystack.cn>,
 Ilya Dryomov <idryomov@gmail.com>, Jens Axboe <axboe@kernel.dk>,
 Julia Lawall <Julia.Lawall@inria.fr>, Nicolas Palix <nicolas.palix@imag.fr>,
 Ricardo Ribalda <ribalda@chromium.org>, Xiubo Li <xiubli@redhat.com>
References: <20250203-converge-secs-to-jiffies-part-two-v2-0-d7058a01fd0e@linux.microsoft.com>
 <20250203-converge-secs-to-jiffies-part-two-v2-1-d7058a01fd0e@linux.microsoft.com>
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
 ceph-devel@vger.kernel.org, linux-block@vger.kernel.org
In-Reply-To: <20250203-converge-secs-to-jiffies-part-two-v2-1-d7058a01fd0e@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:aQc8RcrZc7c8bcNHaQ18iCrIJX16D9D0++QdETw7fZSrfDWQqsc
 K4Gk/cqtNbPZ4gSOIiWA/yDQecBHoggZG1iWIlf1browyUtzxnvEU7n+DPN5fyWA26YKWkI
 ZKtYClolm2KTwF1jw0ruRv8/iQ15ULWedSowFddVZQW3Ctia67sQ/eOv4Bwiat+amAPzRzW
 Gwj6TlyCQIJ5htGV5DZRQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:g9xXUJLcnkU=;BPnZKWpwl3c5/Z81VR1BJF2NLey
 7KmTDfH/dErzC57mKitzacacH5QWXShj7dWV31d+qLWzJcEtI1LHG9pbt1CynKTkcrkdJFAkl
 aTVATFbWRAiKBVj1S0WskrCik+niedHj3rXXJuHTid1iLShvda+2ddnAyuzUJCuiWRHncLXnI
 IZ4m64c2X2DWwJv6guJW2jJUfLtKAPVYUcu8N9KkXbaIGXvqeiMr71auJE4p6GGg4ZTLKNmn0
 JmscL4Jwe5MOz0YyQyJhCSAh9V6CFw9sND0IVmhV6eDi4jWDEqafCQwaiiZ8iAhh0/WIxK+nb
 kip0rSSptO79y1CfZEbzOXmPc1wBPDUmtmD5/QzhInOTjl1UqPGk5GDYw4jTbwYafatxp5xvp
 NzZhiT9jb44JLlBS9p1nW2sbo/ONakwvyoQnX+Ddzz0Njde5RkkZWC9dgNIBMIR8T9MtBhaMY
 5GjZ97gnvL1RigBNu9p0ovNQ/KtEy8avOOzXNyPXoYVk+YQSny4f3/niOL3lolUmpGE6a3HLY
 jtZQcc0QLfYq25/t7nyhtoCAoHuJ6CUJoYLb5K5hlq3ISTP+bS+GepLgo/Pt6NgIJ5xmAfR15
 g03gXL+jHbW6kS9SFZu+z8iewAb2Oy85zWtGhSp1Vgu9hL+ttETwanNZemEDesYoAkhYBqip9
 3DnFTHa4Ay9/VvyvHJ4wyXcypTylcsng4vHLBBsULGgHy2sVMUKWIZ8TtT8BdARS4AsGyElnZ
 f1SlkVkszVA8hDByqAcBNeBKirGIKjKWokP7QEkbDYNVJveJ2DArWXLPcEYw/bDlxV+wDPdnF
 x4fa0AWXaCGUGSujljRizjORr5EVnCo+SgU0pn8UI1Oaad6t+JMw2jOXCa+y25LhE3hYusZG1
 6Yv4kSv3e5Hj81Yw10uYjjHyzitolWuv8Ewbi1Y0Cu/HqmVdIlpQ0VuqelLxZ0tQLQFocOxKW
 S34hOQbQzebRXvPbduDdBe0dKDLTbjVcu7KnOQqTIgnChAdnd0WewxdOBmHJQXH0VkhgZbt69
 gmADZ3PJZS+x8rhXoiuMuT78s+au8M+4S1fYvgi+PRRchhC3OT1zB3eJPKKSv+r0AkzPH9cmp
 FqY+sRwfB6raXh48DoNM32mJJIxQuwPj0bpPFPHTwltJ7NPBjOorSmJ5cYKsHxtMIzSqi+PnC
 lwhuAuCDRgrBUyMZgwsfSdagK64Nc3MxGIkvC+9B6FttH6N+JIV9/o/N7MEUr++voAWGE52sc
 nJrzRJmRv5IUUAr2c9kn9hU1SN4wSQMb/QagvbzoBXT/6OYlmyZ1qhWDat6NRMRF9WJjqPq7U
 9VkVJ6ZREp7rOYzYJ8yLkB0T7Hi4ewJX3cnanqf1/cro/ERdUQlrksVO0529gNS5qm9

> Teach the script to suggest conversions for timeout patterns where the
> arguments to msecs_to_jiffies() are expressions as well.
How do you imagine that the shown SmPL code fits ever to patch reviews?

Examples:
* https://lore.kernel.org/cocci/80cae791-663c-4589-b67e-d4d1049fcd98@web.de/
  https://sympa.inria.fr/sympa/arc/cocci/2025-02/msg00002.html
  https://lkml.org/lkml/2025/2/3/151

* https://lore.kernel.org/cocci/e06cb7f5-7aa3-464c-a8a1-2c7b9b6a29eb@web.de/
  https://sympa.inria.fr/sympa/arc/cocci/2025-01/msg00122.html
  https://lkml.org/lkml/2025/1/30/307


Regards,
Markus

