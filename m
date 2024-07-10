Return-Path: <ceph-devel+bounces-1514-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3FFF92D808
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Jul 2024 20:11:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3EA95281408
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Jul 2024 18:10:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6075319645C;
	Wed, 10 Jul 2024 18:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="RrhaVMJP"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C23D195804;
	Wed, 10 Jul 2024 18:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720635046; cv=none; b=jIcKLXEFdigvlPnXC4aShXgTa1rSO2b+ZVcdkmA12yeGkLjvQXuHu2qaqUWwSA55a7NQKyQ9PIMgdTeK8t9ab4OE3+oH18etzZMRmoXaYTdeDlk+DFxZ48ELEUL+ibZSjp3FRzbfZossgT/tnh71mawRWuOlUth38RPUqI7sSwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720635046; c=relaxed/simple;
	bh=hHHCfh5A1BFPcXMDVvdtZi9gDh1spfHlwA0z6wTrNnU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=fY043wJ4clB22Jr/IKd4ACcXKt5nzNLXVLPfv3qSWMWKlEMR2mf/mXnygUlX/sZtSWt8qGLFn6mZl2bcImtaYaXh6wBsdYJA5lZwc0JTTA+tqXn959DaOUWzJVhZQonpLOhbc8+jf7TLGRBJyVbAKXUAYu5/9007JG40DjfqAr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=RrhaVMJP; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46AB3vRV017022;
	Wed, 10 Jul 2024 18:10:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	MyKfTURKJWbtQIFwuzgvc+qs8ZiJxYlmk1jcTvuSSzs=; b=RrhaVMJPUujgA8by
	RN2xRcr3e5rW+W7pHw+C8VP/a+i+myiEYOCjr8ztuA5/VF4gKjiaQrLjnAr8A99S
	XcgKlz8cqOfr+eiGe/KxnCOYOwv8IPBDkmhhcviFgIbVPqeppdKRqXp5gBii0GrU
	rXsHi36LNpnu2fTfE4rhMdwvmIokFbYY620eHHqSzEKacNdSdi9Ih0WVNTreqHgB
	wjX1/ub9fZVM8w1fAN39R1EKw5meB8EQ/tWQZ1wMW//EATDTTMxHbEntoj+w/TrN
	pV5yyOkeAUA4/VVd5c51LYyipddvFYdl+0F/145rorBsr5to1g2KT/ioVau81Mqb
	zxKXXQ==
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 406y3hhr7y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jul 2024 18:10:31 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA04.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 46AIACbc032715
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jul 2024 18:10:12 GMT
Received: from [169.254.0.1] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Wed, 10 Jul
 2024 11:10:12 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Wed, 10 Jul 2024 11:10:03 -0700
Subject: [PATCH net-next 1/2] libceph: suppress crush_choose_indep()
 kernel-doc warnings
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240710-kd-crush_choose_indep-v1-1-fe2b85f322c6@quicinc.com>
References: <20240710-kd-crush_choose_indep-v1-0-fe2b85f322c6@quicinc.com>
In-Reply-To: <20240710-kd-crush_choose_indep-v1-0-fe2b85f322c6@quicinc.com>
To: Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>,
        "David S.
 Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub
 Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: <ceph-devel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Jeff Johnson <quic_jjohnson@quicinc.com>
X-Mailer: b4 0.14.0
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: PpNerlIMa27KlWL2wwGu7Nj-d0PwExKD
X-Proofpoint-GUID: PpNerlIMa27KlWL2wwGu7Nj-d0PwExKD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-10_13,2024-07-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 spamscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 clxscore=1011 mlxlogscore=901 impostorscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407100128

Currently, when built with "make W=1", the following warnings are
generated:
net/ceph/crush/mapper.c:655: warning: Function parameter or struct member 'map' not described in 'crush_choose_indep'
net/ceph/crush/mapper.c:655: warning: Function parameter or struct member 'work' not described in 'crush_choose_indep'
net/ceph/crush/mapper.c:655: warning: Function parameter or struct member 'bucket' not described in 'crush_choose_indep'
net/ceph/crush/mapper.c:655: warning: Function parameter or struct member 'weight' not described in 'crush_choose_indep'
net/ceph/crush/mapper.c:655: warning: Function parameter or struct member 'weight_max' not described in 'crush_choose_indep'
net/ceph/crush/mapper.c:655: warning: Function parameter or struct member 'x' not described in 'crush_choose_indep'
net/ceph/crush/mapper.c:655: warning: Function parameter or struct member 'left' not described in 'crush_choose_indep'
net/ceph/crush/mapper.c:655: warning: Function parameter or struct member 'numrep' not described in 'crush_choose_indep'
net/ceph/crush/mapper.c:655: warning: Function parameter or struct member 'type' not described in 'crush_choose_indep'
net/ceph/crush/mapper.c:655: warning: Function parameter or struct member 'out' not described in 'crush_choose_indep'
net/ceph/crush/mapper.c:655: warning: Function parameter or struct member 'outpos' not described in 'crush_choose_indep'
net/ceph/crush/mapper.c:655: warning: Function parameter or struct member 'tries' not described in 'crush_choose_indep'
net/ceph/crush/mapper.c:655: warning: Function parameter or struct member 'recurse_tries' not described in 'crush_choose_indep'
net/ceph/crush/mapper.c:655: warning: Function parameter or struct member 'recurse_to_leaf' not described in 'crush_choose_indep'
net/ceph/crush/mapper.c:655: warning: Function parameter or struct member 'out2' not described in 'crush_choose_indep'
net/ceph/crush/mapper.c:655: warning: Function parameter or struct member 'parent_r' not described in 'crush_choose_indep'
net/ceph/crush/mapper.c:655: warning: Function parameter or struct member 'choose_args' not described in 'crush_choose_indep'

These warnings are generated because the prologue comment for
crush_choose_indep() uses the kernel-doc prefix, but the actual
comment is a very brief description that is not in kernel-doc
format. Since this is a static function there is no need to fully
document the function, so replace the kernel-doc comment prefix with a
standard comment prefix to remove these warnings.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
 net/ceph/crush/mapper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ceph/crush/mapper.c b/net/ceph/crush/mapper.c
index 1daf95e17d67..3194d5090963 100644
--- a/net/ceph/crush/mapper.c
+++ b/net/ceph/crush/mapper.c
@@ -636,7 +636,7 @@ static int crush_choose_firstn(const struct crush_map *map,
 }
 
 
-/**
+/*
  * crush_choose_indep: alternative breadth-first positionally stable mapping
  *
  */

-- 
2.42.0


