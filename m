Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2447E40014B
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Sep 2021 16:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349487AbhICOcM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 3 Sep 2021 10:32:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11016 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S245253AbhICOcK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 3 Sep 2021 10:32:10 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 183E6ICT026116;
        Fri, 3 Sep 2021 10:30:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=K1dk/P2wTpVI0p3QS3od3mHTburBeWR5dUPZNm4udps=;
 b=j0I0w/iXGypIbDpx/9Wc7NKetsfLRypj6wFIqBJkCaIZgssBV0fHHzA3gt8HYyR/oWCM
 sMPBRS/SP0EYikutM+CLa2xxvB4dM+EI2yxw6+qt3L9x8q/NDvgFgE/B/9l/mQg/42dO
 fzmt/9lDlWjijJGNhKXys6/A8qVoD7qIBS247VhF5ycLZt5Awlxqhf2xfus7c8ENwWhk
 nIFYVZHgNV5wKBB1Koa+uj+hVLC/70npbU7CHAwqRaHSCz+HovzmXRP49QMbQjSQty/d
 KrV9LAdprASeGVVaLeXONQtlIO6T6PjmPRSwj1mGaNAdaWtbuQJ4/dJs5DzXZ7PEKsTU mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3aukatbgkh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Sep 2021 10:30:48 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 183E6fhJ028767;
        Fri, 3 Sep 2021 10:30:48 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3aukatbghf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Sep 2021 10:30:48 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 183ECDI1003658;
        Fri, 3 Sep 2021 14:30:45 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3au6q7h7vs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Sep 2021 14:30:44 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 183EUf9J45679086
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Sep 2021 14:30:41 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3572EA4064;
        Fri,  3 Sep 2021 14:30:41 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22229A4072;
        Fri,  3 Sep 2021 14:30:40 +0000 (GMT)
Received: from osiris (unknown [9.145.159.114])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  3 Sep 2021 14:30:40 +0000 (GMT)
Date:   Fri, 3 Sep 2021 16:30:38 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     axboe@kernel.dk, gregkh@linuxfoundation.org,
        chaitanya.kulkarni@wdc.com, atulgopinathan@gmail.com, hare@suse.de,
        maximlevitsky@gmail.com, oakad@yahoo.com, ulf.hansson@linaro.org,
        colin.king@canonical.com, shubhankarvk@gmail.com,
        baijiaju1990@gmail.com, trix@redhat.com,
        dongsheng.yang@easystack.cn, ceph-devel@vger.kernel.org,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        sth@linux.ibm.com, hoeppner@linux.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, oberpar@linux.ibm.com, tj@kernel.org,
        linux-s390@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] s390/block/scm_blk: add error handling support for
 add_disk()
Message-ID: <YTIxjn1X0ES8my2a@osiris>
References: <20210902174105.2418771-1-mcgrof@kernel.org>
 <20210902174105.2418771-9-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902174105.2418771-9-mcgrof@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: V2U5m9F_lW0BS0QMZW1f02Rb7B-NE_bq
X-Proofpoint-ORIG-GUID: mLI1i5uQ2HrD42lfDNoMT2JI_B9gbecH
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-03_05:2021-09-03,2021-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 bulkscore=0 phishscore=0
 mlxscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109030088
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Sep 02, 2021 at 10:41:04AM -0700, Luis Chamberlain wrote:
> We never checked for errors on add_disk() as this function
> returned void. Now that this is fixed, use the shiny new
> error handling.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  drivers/s390/block/scm_blk.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

Acked-by: Heiko Carstens <hca@linux.ibm.com>
