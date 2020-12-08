Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF682D233F
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Dec 2020 06:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgLHFbV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Dec 2020 00:31:21 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:48806 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgLHFbU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Dec 2020 00:31:20 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B85PHPT160169;
        Tue, 8 Dec 2020 05:30:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=RYDs4ol5IVVSDY/Fix9p9GIjOBXHFpORQWCmocH6LXM=;
 b=qcKJ4A4MCtOa6wOZg/TnoXrFYchwkJHtHAJCuwQkq2CLo6+fU8qTc5Sn+jEsKT6ZnSY7
 2orwLneXBY/K1wADuO4Uz5UzYMdM4I0/hrsNUJPJLhCDLPditrTI+u1CL+NmZsOh1EAd
 iT+7G605y2n6+mXusw8zJtfxMK3zlMrkC2ZcYD89ae8LrmNu56pIBQPdSo1GR/JiGvqK
 NhhoFS7tOnSIYUEeKRW7yZq7/ISXEgKDeF1S6YRysfvRgk0YD+qG7DJBSMP3SiXcZC4j
 +Xn7RY7GXWVlOKFaC8A2ohKyh+OrleYA52+DeU0QsDCwye8el/OmfoiWvn9QS1N3vlPq +w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 357yqbryw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 08 Dec 2020 05:30:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B85Qble057632;
        Tue, 8 Dec 2020 05:30:21 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 358kysb5g0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Dec 2020 05:30:21 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B85UKmS013740;
        Tue, 8 Dec 2020 05:30:20 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 21:30:19 -0800
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Oleksii Kurochko <olkuroch@cisco.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Mike Snitzer <snitzer@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        ceph-devel@vger.kernel.org, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/6] rbd: remove the ->set_read_only method
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7owx3ts.fsf@ca-mkp.ca.oracle.com>
References: <20201207131918.2252553-1-hch@lst.de>
        <20201207131918.2252553-6-hch@lst.de>
Date:   Tue, 08 Dec 2020 00:30:17 -0500
In-Reply-To: <20201207131918.2252553-6-hch@lst.de> (Christoph Hellwig's
        message of "Mon, 7 Dec 2020 14:19:17 +0100")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=1 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080032
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


Christoph,

> Now that the hardware read-only state can't be changed by the BLKROSET
> ioctl, the code in this method is not required anymore.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
