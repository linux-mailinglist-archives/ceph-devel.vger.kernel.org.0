Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B65551A1FB9
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Apr 2020 13:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbgDHLTo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Apr 2020 07:19:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49074 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727902AbgDHLTo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Apr 2020 07:19:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 038BDrwD027006;
        Wed, 8 Apr 2020 11:19:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=xisUelroGbqcUhwdgaWuelxoKea/Nh0/TCJUVHXaaG8=;
 b=JaqPB3xVexZZEEdQEHeFUFTH4uod0wxos+a0rm+Nd9DKUXBXqm3M0OKJewDEtv2N1mYZ
 xw1T0HcQCMTiqkFqH0GfzNklMGQ65LvBKsbEGuHxAfZ674+5DM3OVQH+6XsK6DHDjEBE
 Eki4fWn2uBTor8ox20xOu/B3ErcF6ozSwmLMiSylfdDlucxCk8Czi5x/Z/Kpdm0SatF9
 Bvo9pThX1PJAW9m00L8WHDBJ9hkK3VWHEYjGAYb7S0KwMtzgwH+L8bmYK7nqM8djMB4C
 DQaX71fvrf1eW6Jf2KJIg1UMiwwS+54/zEw2TQGj3RqVHuQFfr0xmbcr+WD59m3ICg+7 9A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3091m0txch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 11:19:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 038BCYHo001469;
        Wed, 8 Apr 2020 11:17:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3099v8rpk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 11:17:40 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 038BHe8S003470;
        Wed, 8 Apr 2020 11:17:40 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 Apr 2020 04:17:39 -0700
Date:   Wed, 8 Apr 2020 14:17:34 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     jlayton@kernel.org
Cc:     ceph-devel@vger.kernel.org
Subject: [bug report] ceph: attempt to do async create when possible
Message-ID: <20200408111734.GA252918@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 mlxlogscore=625 bulkscore=0 spamscore=0 phishscore=0 suspectscore=10
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004080094
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=673 mlxscore=0
 priorityscore=1501 phishscore=0 suspectscore=10 bulkscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 clxscore=1011
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080094
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello Jeff Layton,

The patch 9a8d03ca2e2c: "ceph: attempt to do async create when
possible" from Nov 27, 2019, leads to the following static checker
warning:

	fs/ceph/file.c:540 ceph_async_create_cb()
	error: uninitialized symbol 'base'.

fs/ceph/file.c
   526          mapping_set_error(req->r_parent->i_mapping, result);
   527  
   528          if (result) {
   529                  struct dentry *dentry = req->r_dentry;
   530                  int pathlen;
   531                  u64 base;
                        ^^^^^^^^
   532                  char *path = ceph_mdsc_build_path(req->r_dentry, &pathlen,
   533                                                    &base, 0);
                                                          ^^^^^
   534  
   535                  ceph_dir_clear_complete(req->r_parent);
   536                  if (!d_unhashed(dentry))
   537                          d_drop(dentry);
   538  
   539                  /* FIXME: start returning I/O errors on all accesses? */
   540                  pr_warn("ceph: async create failure path=(%llx)%s result=%d!\n",
   541                          base, IS_ERR(path) ? "<<bad>>" : path, result);
                                ^^^^
Potentialy uninitialized on error.

   542                  ceph_mdsc_free_path(path, pathlen);
   543          }
   544  
   545          if (req->r_target_inode) {

regards,
dan carpenter
