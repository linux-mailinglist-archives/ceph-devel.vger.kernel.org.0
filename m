Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64B291701B7
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Feb 2020 15:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgBZO7i (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Feb 2020 09:59:38 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34562 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgBZO7h (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Feb 2020 09:59:37 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01QErrtM067446;
        Wed, 26 Feb 2020 14:59:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=01nVfQ8FJtqdM15VrQzYuRumF4vncz8CG9Xog9Y2Exk=;
 b=i2QPf5Owx+MpwbOKgXmhuamOPkxo7b81qHl96sttk6hAP+DGjakPdCxS1aEylbg/9ysz
 VsjksgCwTOPpamvAErHl5ccJGNU7PRFMWvdPuB4R8g9ZCCGFltC5pp6CJineX2tvcY69
 XhZp+Pq18EP/Cj9ecKatHC1V78m8JBxKWIKjbVdrSAWXgsXjSO13sePTSRYGFOenaaxu
 w9rves+s1qveAbeepjl+bLjHr+E8mJ/ogZqyAvMBgR+KapJW1lNAN4dlLpJpyi5y8Grg
 mS4SLlI9ChMztIhsfTV3qJG/FBOVb1VVQqKTO8x7ufG+J1Rx/uQobcmjXmZZToT3UJxy Ow== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2ydcsrm4r5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 14:59:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01QEqInZ177075;
        Wed, 26 Feb 2020 14:59:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2ydcs55sqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 14:59:34 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01QExXxU012332;
        Wed, 26 Feb 2020 14:59:33 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Feb 2020 06:59:33 -0800
Date:   Wed, 26 Feb 2020 17:59:27 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org
Subject: [bug report] libceph: revamp subs code, switch to SUBSCRIBE2 protocol
Message-ID: <20200226145927.jtuc5bgiojhoefad@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=645 spamscore=0 suspectscore=1 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260108
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=1
 bulkscore=0 malwarescore=0 spamscore=0 impostorscore=0 clxscore=1011
 lowpriorityscore=0 mlxlogscore=694 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260108
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello Ilya Dryomov,

The patch 82dcabad750a: "libceph: revamp subs code, switch to
SUBSCRIBE2 protocol" from Jan 19, 2016, leads to the following static
checker warning:

	net/ceph/mon_client.c:495 ceph_monc_handle_map()
	error: dereferencing freed memory 'monc->monmap'

net/ceph/mon_client.c
   466  static void ceph_monc_handle_map(struct ceph_mon_client *monc,
   467                                   struct ceph_msg *msg)
   468  {
   469          struct ceph_client *client = monc->client;
   470          struct ceph_monmap *monmap = NULL, *old = monc->monmap;
                                                    ^^^^^^^^^^^^^^^^^^

   471          void *p, *end;
   472  
   473          mutex_lock(&monc->mutex);
   474  
   475          dout("handle_monmap\n");
   476          p = msg->front.iov_base;
   477          end = p + msg->front.iov_len;
   478  
   479          monmap = ceph_monmap_decode(p, end);
   480          if (IS_ERR(monmap)) {
   481                  pr_err("problem decoding monmap, %d\n",
   482                         (int)PTR_ERR(monmap));
   483                  ceph_msg_dump(msg);
   484                  goto out;
   485          }
   486  
   487          if (ceph_check_fsid(monc->client, &monmap->fsid) < 0) {
   488                  kfree(monmap);
   489                  goto out;
   490          }
   491  
   492          client->monc.monmap = monmap;
   493          kfree(old);
                      ^^^
Frees monc->monmap.

   494  
   495          __ceph_monc_got_map(monc, CEPH_SUB_MONMAP, monc->monmap->epoch);
                                                           ^^^^^^^^^^^^
Should this be "client->monc.monmap" or maybe just "monmap"?

   496          client->have_fsid = true;
   497  
   498  out:
   499          mutex_unlock(&monc->mutex);
   500          wake_up_all(&client->auth_wq);
   501  }

regards,
dan carpenter
