Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0249C401D12
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Sep 2021 16:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243447AbhIFOhC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Sep 2021 10:37:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:65104 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243421AbhIFOhB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Sep 2021 10:37:01 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 186EYWcw092852;
        Mon, 6 Sep 2021 10:35:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=t5OR0eUDklpD1WGcingITtl2OO+Tv7Am9adn1Pg8ob8=;
 b=Fg5yauhmATD6QI5Na7k8vSPW5iTgGoMSjYH5iBmL2WQAHem/LLdTfeyfvHKh/Ta5fuOu
 u2cQFR2ixl8pEwImQgKY5qk2q1bNRqY9w/LCTSNtkKdE+6Di68i3mKZeeMTw7cDsBCjN
 lP3qqMU/HCRWZfFaKElSULlrf9L12xixT63jXCC1HqoV/R7ujHNzZA+iZYezwPDaxgWO
 6hVLfY/TJwmcDZAL8wwEBkKOA/UDBAImf38T7LQNH6fqBbdQqRvYpVb6U4uRZoKY9rZG
 4qk9cTJEO6YzOC8M7BxWdldZdzFnFH5EuchBQLQrG4J0UMabuxBnaQcAS2KvX+VSviXW Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3awh9cwbev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Sep 2021 10:35:18 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 186EZImE100053;
        Mon, 6 Sep 2021 10:35:18 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3awh9cwbdx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Sep 2021 10:35:17 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 186EXUwh023137;
        Mon, 6 Sep 2021 14:35:15 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3av02j4kq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Sep 2021 14:35:15 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 186EZBZp46072230
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Sep 2021 14:35:11 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 722F8AE065;
        Mon,  6 Sep 2021 14:35:11 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C4D9AE055;
        Mon,  6 Sep 2021 14:35:10 +0000 (GMT)
Received: from osiris (unknown [9.145.3.161])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon,  6 Sep 2021 14:35:10 +0000 (GMT)
Date:   Mon, 6 Sep 2021 16:35:09 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Christoph Hellwig <hch@infradead.org>
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
Subject: Re: [PATCH 9/9] s390/block/xpram: add error handling support for
 add_disk()
Message-ID: <YTYnHUYSfB6YElnh@osiris>
References: <20210902174105.2418771-1-mcgrof@kernel.org>
 <20210902174105.2418771-10-mcgrof@kernel.org>
 <YTIr1w/qPvgioUfL@osiris>
 <YTXcPBph323n2WJ8@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTXcPBph323n2WJ8@infradead.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hBKOiASlRVgdP6m0ZVyfrL0h5Yz4Ft1A
X-Proofpoint-ORIG-GUID: sRBTe9g0KJq9hO82J9XVDCM7Uj8j1L5y
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-06_06:2021-09-03,2021-09-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 spamscore=0
 phishscore=0 impostorscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109060092
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Sep 06, 2021 at 10:15:40AM +0100, Christoph Hellwig wrote:
> On Fri, Sep 03, 2021 at 04:06:15PM +0200, Heiko Carstens wrote:
> > Hmm, this is a more or less dead device driver, and I'm wondering if
> > we shouldn't remove it instead. But anyway, your patch is not correct:
> 
> I'm all for removing it.  I think we need to do a little more spring
> cleaning on unmaintained and likely to be unused block drivers.

Yes, we'll remove it. I'll schedule it even for this merge
window. Should be away with -rc1.
