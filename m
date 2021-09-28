Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8261C41AAD9
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Sep 2021 10:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239728AbhI1Iqa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 Sep 2021 04:46:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39034 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239618AbhI1Iq3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 28 Sep 2021 04:46:29 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18S8NPRj005548;
        Tue, 28 Sep 2021 04:44:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=zBxfoBHkX8WZAFCzMW2WEkfCuH/znFi5cWiwbPqjqWM=;
 b=EGz9+271qGmkpAW3qZvfm5GhIfGvLkS9sQHypX5tsIotlkKWr2kV5oZY0YMYsWdeJIN7
 eUiRtCOCChOG9S8wIuGLIB2rLSTZa72xcVtajiOCtIpNi2CP8QArSEXGwiaiYw9EBVKL
 LHWObPhD6knPvm9aZh+SuHO92g3B6klmYQ1Sm6zqls3XkEqKAwclCbyjyKXGiH/nyJ6a
 B9K7lPZNN2FdYQZEzeJckB5wcVAZegaPQll5SQJGMHx08o1OOsCTWJp+Jg27qaBQOXLq
 Ll/w5rTWdDU0tzcImRkxehDQzZxDrcDjpG+P3c4PkbvhWPq/b4p6hTafmqFBgBSWQlbc sQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bagsfe4rh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 04:44:23 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18S8iNuH031289;
        Tue, 28 Sep 2021 04:44:23 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bagsfe4qw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 04:44:23 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18S8hFQQ031611;
        Tue, 28 Sep 2021 08:44:20 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3b9u1jbtpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 08:44:20 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18S8iGao59572508
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 08:44:16 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA92E11C06C;
        Tue, 28 Sep 2021 08:44:16 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 951DF11C069;
        Tue, 28 Sep 2021 08:44:15 +0000 (GMT)
Received: from osiris (unknown [9.145.163.77])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 28 Sep 2021 08:44:15 +0000 (GMT)
Date:   Tue, 28 Sep 2021 10:44:14 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Luis Chamberlain <mcgrof@kernel.org>, gregkh@linuxfoundation.org,
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
Subject: Re: [PATCH v2 0/6] block: 5th batch of add_disk() error handling
 conversions
Message-ID: <YVLV3s66GVVSQ+tj@osiris>
References: <20210927220232.1071926-1-mcgrof@kernel.org>
 <25afa23b-52af-9b79-8bd8-5e31da62c291@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25afa23b-52af-9b79-8bd8-5e31da62c291@kernel.dk>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YxG9ke3W_jbTNpwVPcs7XrGQVIxP9RN0
X-Proofpoint-ORIG-GUID: iz_w5IRro-Zutc101Wh7ZoX-CWSF6VdI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_04,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 mlxscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280050
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Sep 27, 2021 at 04:32:17PM -0600, Jens Axboe wrote:
> On 9/27/21 4:02 PM, Luis Chamberlain wrote:
> > This is the 5th series of driver conversions for add_disk() error
> > handling. This set along with the entire 7th set of patches can be
> > found on my 20210927-for-axboe-add-disk-error-handling branch [0].
> 
> Applied 1-2.

Hmm.. naturally I would have expected that the dasd patch also would
go via block tree. But let's not spend too much time figuring out what
gets routed where.
Applied 4-6. Thanks!
