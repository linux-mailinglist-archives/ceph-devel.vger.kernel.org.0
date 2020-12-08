Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F4C2D233B
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Dec 2020 06:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgLHFan (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Dec 2020 00:30:43 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49884 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726172AbgLHFan (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Dec 2020 00:30:43 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B85OES9195639;
        Tue, 8 Dec 2020 05:29:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=8w2ZAhtsPbCfHCqQAr6ORaFBF8DcabF81HehDcpjwdo=;
 b=bfsmrb+ZHrCDmhgci3/aSOxHXW+oht+0NaoM1zE/MBFGErzj5DxaFfOBs7rPr9ydjfMM
 CJ/caqyLCnsNvFMNZF7ivGLt5eezDeoTDydvpd1ifRN+YhSxuPSATbR2ruo7w11M/R/K
 FZ5ce3AcJ17dKdYNHijgM+VRPXRQkQoSG3HSng6T5dNuxoxHzkj6yCPixWg8VKIEdZ2P
 aAGjsxqAfCQNjXPtg/mGhTHElbwOFi71evFRoVw9yZDaN1x0BP3J+NZ4KokYiFjI1B8s
 2VMNsQrSoK1GsEYhPRoxt5kVduQ/SIhjZ80kgvLYzv+l/HOwmWzhM8JvW2xaUn9GjOUZ gQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3581mqru8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 08 Dec 2020 05:29:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B85Qb1d058091;
        Tue, 8 Dec 2020 05:29:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 358m3x8fwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Dec 2020 05:29:47 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B85Tk3I013500;
        Tue, 8 Dec 2020 05:29:46 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 21:29:45 -0800
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Oleksii Kurochko <olkuroch@cisco.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Mike Snitzer <snitzer@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        ceph-devel@vger.kernel.org, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH 6/6] nvme: allow revalidate to set a namespace read-only
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtyox3uo.fsf@ca-mkp.ca.oracle.com>
References: <20201207131918.2252553-1-hch@lst.de>
        <20201207131918.2252553-7-hch@lst.de>
Date:   Tue, 08 Dec 2020 00:29:43 -0500
In-Reply-To: <20201207131918.2252553-7-hch@lst.de> (Christoph Hellwig's
        message of "Mon, 7 Dec 2020 14:19:18 +0100")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=1 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080032
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


Christoph,

> Unconditionally call set_disk_ro now that it only updates the hardware
> state.  This allows to properly set up the Linux devices read-only when
> the controller turns a previously writable namespace read-only.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
