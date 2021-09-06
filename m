Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58245401D17
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Sep 2021 16:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243471AbhIFOhe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Sep 2021 10:37:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7922 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236950AbhIFOh2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Sep 2021 10:37:28 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 186EB0cd093954;
        Mon, 6 Sep 2021 10:34:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=K9YoRjs+OVJTZWwE3aqGWgWmXGlfnLRk4vE6zXW/7MI=;
 b=pr6D7d1d18e9uwZlU0Ty8GzNce4SEulx18mGcF9L1kEJ+zwvsOlx2ic4beSbSKw26JXq
 +wabtQ6fpEzwdqEUSQHic1lITg/cwVqj2Q9qvwIMCxTPnmi7I9/KTvTxJIpE4M3WM14v
 HYDFATUechLGhhqevTYTmAG5IXFY/tsxIuKqHi3m4r5SPjgAoEk5be+4X9Ttpy82h96g
 fh5avbZFBx/ShTM0cCfRkPrxAMtwX+VSP+LliZEDjWMy+NMGkZhRKG+NSJI4ZCJCUQV+
 gebnm3jalueksIc+cPWp9KV8M6hqjwyRk4edwR6GL+1FQWUA2fUN0+1R8Cr9CPFKM6e2 Nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3awhbyn14m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Sep 2021 10:34:04 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 186EB02d093867;
        Mon, 6 Sep 2021 10:34:03 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3awhbyn13w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Sep 2021 10:34:03 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 186EX2rL017980;
        Mon, 6 Sep 2021 14:34:01 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3av0e9chec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Sep 2021 14:34:01 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 186EXwhM54198718
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Sep 2021 14:33:58 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F4D3AE058;
        Mon,  6 Sep 2021 14:33:58 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 49EFEAE05D;
        Mon,  6 Sep 2021 14:33:57 +0000 (GMT)
Received: from osiris (unknown [9.145.3.161])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon,  6 Sep 2021 14:33:57 +0000 (GMT)
Date:   Mon, 6 Sep 2021 16:33:55 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>, axboe@kernel.dk,
        gregkh@linuxfoundation.org, chaitanya.kulkarni@wdc.com,
        atulgopinathan@gmail.com, hare@suse.de, maximlevitsky@gmail.com,
        oakad@yahoo.com, ulf.hansson@linaro.org, colin.king@canonical.com,
        shubhankarvk@gmail.com, baijiaju1990@gmail.com, trix@redhat.com,
        dongsheng.yang@easystack.cn, ceph-devel@vger.kernel.org,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        sth@linux.ibm.com, hoeppner@linux.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, oberpar@linux.ibm.com, tj@kernel.org,
        linux-s390@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] s390/block/dcssblk: add error handling support for
 add_disk()
Message-ID: <YTYm09U6jZUDtB9l@osiris>
References: <20210902174105.2418771-1-mcgrof@kernel.org>
 <20210902174105.2418771-8-mcgrof@kernel.org>
 <YTIscKy+jg5L/TMh@osiris>
 <YTLP8mYBX37R++9E@bombadil.infradead.org>
 <20210906134346.19c14246@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210906134346.19c14246@thinkpad>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oSOWQOHMJCB8KRa2gHe6rtDES0-9leq3
X-Proofpoint-ORIG-GUID: uWvV3nnx5hIse_lWekuNz15Kr0UNPFaR
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-06_06:2021-09-03,2021-09-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 mlxscore=0 impostorscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015
 mlxlogscore=999 priorityscore=1501 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109060090
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Sep 06, 2021 at 01:43:46PM +0200, Gerald Schaefer wrote:
> On Fri, 3 Sep 2021 18:46:26 -0700
> Luis Chamberlain <mcgrof@kernel.org> wrote:
> > > > +	rc = device_add_disk(&dev_info->dev, dev_info->gd, NULL);
> > > > +	if (rc)
> > > > +		goto put_dev;
> > > 
> > > This looks not correct to me. We seem to have now in case of an error:
> > > 
> > > - reference count imbalance (= memory leak)
> > > - dax cleanup is missing
> > 
> > Care to provide an alternative?
> 
> See patch below:
> 
> From 7053b5f8c0a126c3ef450de3668d9963bd68ceaa Mon Sep 17 00:00:00 2001
> From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> Date: Mon, 6 Sep 2021 13:18:53 +0200
> Subject: [PATCH] s390/block/dcssblk: add error handling support for add_disk()
> 
> Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> ---
>  drivers/s390/block/dcssblk.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)

Thanks Gerald! FWIW:
Acked-by: Heiko Carstens <hca@linux.ibm.com>
