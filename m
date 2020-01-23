Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0B3146CDA
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Jan 2020 16:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgAWPao (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Jan 2020 10:30:44 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:53446 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727278AbgAWPan (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 23 Jan 2020 10:30:43 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00NFDMSk136782;
        Thu, 23 Jan 2020 15:30:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=pF2L6fD9pUnY7bIKUsSkHD7KoFA6r5OeYEYMsrSoa80=;
 b=YnxSsDgy7NEOcgRYihiFQQZKOZ5fUkHGPXMolRwVg/dw37S4zWfH/1Hage+WM5G7bkjt
 MtA3/ebBO51EPpfwKK4J76XFCHbV4xtd3l3M4O37zGMnfSv3LAMVQYBs9lZlaMP/IxS2
 6GTD1Fu9s8S874gyPWg0sxGFixVBKpNTiRDV4sCMkyvQTlpVzoLc9ApHgsBfMHeJhP83
 +yxktd57XFzzvifumF3jrH5CWZu/M1rCmOu8nt0Tj2X3hzjZWpNjiCd+z5F8PDjiTbnD
 4JZ/Z/wgjuvP3dMZKFy7BPnFtz3845956gn4qqGyEAecUwG8l+O4lY+pfYX3Ljp/hLM/ tw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2xktnrjuka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 15:30:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00NFDsVP127600;
        Thu, 23 Jan 2020 15:30:40 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2xpq0wqxbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 15:30:40 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00NFUcsn001338;
        Thu, 23 Jan 2020 15:30:38 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 07:30:38 -0800
Date:   Thu, 23 Jan 2020 18:30:31 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     jlayton@kernel.org
Cc:     ceph-devel@vger.kernel.org
Subject: [bug report] ceph: perform asynchronous unlink if we have sufficient
 caps
Message-ID: <20200123153031.o53tzem7bhedyubg@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9508 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=289
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001230126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9508 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=343 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001230126
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello Jeff Layton,

The patch d6566c62c529: "ceph: perform asynchronous unlink if we have
sufficient caps" from Apr 2, 2019, leads to the following static
checker warning:

	fs/ceph/dir.c:1059 get_caps_for_async_unlink()
	error: uninitialized symbol 'got'.

fs/ceph/dir.c
  1051  static bool get_caps_for_async_unlink(struct inode *dir, struct dentry *dentry)
  1052  {
  1053          struct ceph_inode_info *ci = ceph_inode(dir);
  1054          struct ceph_dentry_info *di;
  1055          int ret, want, got;
  1056  
  1057          want = CEPH_CAP_FILE_EXCL | CEPH_CAP_DIR_UNLINK;
  1058          ret = ceph_try_get_caps(dir, 0, want, true, &got);
  1059          dout("Fx on %p ret=%d got=%d\n", dir, ret, got);
                                                           ^^^
Uninitialized on error.

  1060          if (ret != 1 || got != want)
  1061                  return false;
  1062  
  1063          spin_lock(&dentry->d_lock);
  1064          di = ceph_dentry(dentry);

regards,
dan carpenter
