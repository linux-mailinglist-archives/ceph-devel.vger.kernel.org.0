Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6DF11A1FBA
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Apr 2020 13:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbgDHLVH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Apr 2020 07:21:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59980 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727902AbgDHLVG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Apr 2020 07:21:06 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 038BEAqV014765;
        Wed, 8 Apr 2020 11:21:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=P0cBFJTbhvAwNaxqEUKvqH0yxKr6f/GxJsiC0ArKdHg=;
 b=plShwQogwLv/avooT9O9xk6WzzisY5yZQdzN3oGP2Q4EX2Hb6bLfyQd2cVMQ9DUhk05i
 exvcRiVOjpoSTCGagjV9Pu/x+AHemoic6Gnj05nEb+8I6rHy9btcKuHNd7ukqraZcA43
 7ZYPaZ3aE0vCvk2f/BjTpPt0/KftHEOLo6y+Jx5QhQa9AuQhvbSiGwUZPWDPu9chMlpN
 Rc2KG/i0WD4XOGJXjfOGKvW/yD0C3TabDITZKf4/1L+vG0oqwmdCmGOxRqDpJw3otcIx
 JKBGG1kajSjLwv7FjK5ZZJBid6yb3jjDuLLvbnrRGMkQF+y8R6It0vPY8ntW/6StcbLa vw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3091m3ay3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 11:21:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 038BHY4q025795;
        Wed, 8 Apr 2020 11:21:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3091m3gxq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 11:21:03 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 038BL2Lu027509;
        Wed, 8 Apr 2020 11:21:02 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 Apr 2020 04:21:01 -0700
Date:   Wed, 8 Apr 2020 14:20:55 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     jlayton@kernel.org
Cc:     ceph-devel@vger.kernel.org
Subject: Re: [bug report] ceph: attempt to do async create when possible
Message-ID: <20200408112055.GM2066@kadam>
References: <20200408111734.GA252918@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408111734.GA252918@mwanda>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=3 mlxlogscore=689
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004080095
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=739
 priorityscore=1501 clxscore=1015 bulkscore=0 phishscore=0 mlxscore=0
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080094
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Apr 08, 2020 at 02:17:34PM +0300, Dan Carpenter wrote:
> Hello Jeff Layton,
> 
> The patch 9a8d03ca2e2c: "ceph: attempt to do async create when
> possible" from Nov 27, 2019, leads to the following static checker
> warning:
> 
> 	fs/ceph/file.c:540 ceph_async_create_cb()
> 	error: uninitialized symbol 'base'.
> 
> fs/ceph/file.c
>    526          mapping_set_error(req->r_parent->i_mapping, result);
>    527  
>    528          if (result) {
>    529                  struct dentry *dentry = req->r_dentry;
>    530                  int pathlen;
>    531                  u64 base;
>                         ^^^^^^^^
>    532                  char *path = ceph_mdsc_build_path(req->r_dentry, &pathlen,
>    533                                                    &base, 0);
>                                                           ^^^^^
>    534  
>    535                  ceph_dir_clear_complete(req->r_parent);
>    536                  if (!d_unhashed(dentry))
>    537                          d_drop(dentry);
>    538  
>    539                  /* FIXME: start returning I/O errors on all accesses? */
>    540                  pr_warn("ceph: async create failure path=(%llx)%s result=%d!\n",
>    541                          base, IS_ERR(path) ? "<<bad>>" : path, result);
>                                 ^^^^
> Potentialy uninitialized on error.
> 
>    542                  ceph_mdsc_free_path(path, pathlen);
                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Also this is quite problematic.  "pathlen" can be uninitialized, but
even worse the ceph_mdsc_free_path() assumes "path" is NULL on error
instead of an error pointer.

>    543          }
>    544  
>    545          if (req->r_target_inode) {

regards,
dan carpenter
