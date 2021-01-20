Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0342FD11D
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Jan 2021 14:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389578AbhATNFe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Jan 2021 08:05:34 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:43666 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390071AbhATMny (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 20 Jan 2021 07:43:54 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10KCegL0103501;
        Wed, 20 Jan 2021 12:43:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=a0khsQhU5OWikRaBgJ1+ez6gc91NMazuf/VkpLa57kI=;
 b=LRvcG4dxxsVfnvKUoAAOwsvSX9n1m0mIwrVylzffsI4Z4pFrbt2PpA5RwgftrYsfD9/2
 0qCM8gBfJUPaQRxLmIr8hAaYPcFI25MHWjhgkOxqwXfRiKMrXYVwLccFrfm8YHJtn7V/
 CcaI4+sgOn8HCwm5dSEDMJp+sefFDXzALqJNphYPzeKbV2CukNo9Fp7mCez+HepHXrJG
 SBMopyHElujt43BLlU779k354q74zFlQHINXgfTbvnk+XlaD955tQxeTLsnf06Eaf6Y0
 5gs925zDVQh8JUoXf26uQrmBRnLBX/LCQXSJ5fTQthXkXj19jmiDbZBs/xPUcn4QnkgR AA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 3668qra90w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jan 2021 12:43:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10KCZpqM099774;
        Wed, 20 Jan 2021 12:41:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3668rdv1hg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jan 2021 12:41:07 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10KCf66m012980;
        Wed, 20 Jan 2021 12:41:06 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Jan 2021 04:41:05 -0800
Date:   Wed, 20 Jan 2021 15:40:55 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     kbuild@lists.01.org, kbuild test robot <lkp@intel.com>,
        kbuild-all@lists.01.org, LKML <linux-kernel@vger.kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>
Subject: Re: [kbuild] net/ceph/messenger_v1.c:1099:23: warning: Boolean
 result is used in bitwise operation. Clarify expression with parentheses.
Message-ID: <20210120124055.GG20820@kadam>
References: <20210119194646.GA20820@kadam>
 <CAOi1vP-7AYWiJJganaUROaGiyJA8ejUmbx90uetwsV23KYGNFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOi1vP-7AYWiJJganaUROaGiyJA8ejUmbx90uetwsV23KYGNFw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9869 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101200074
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9869 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101200074
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jan 20, 2021 at 12:01:59PM +0100, Ilya Dryomov wrote:
> On Tue, Jan 19, 2021 at 8:46 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
> >
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git   master
> > head:   1e2a199f6ccdc15cf111d68d212e2fd4ce65682e
> > commit: 2f713615ddd9d805b6c5e79c52e0e11af99d2bf1 libceph: move msgr1 protocol implementation to its own file
> > compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
> >
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> >
> >
> > cppcheck possible warnings: (new ones prefixed by >>, may not real problems)
> >
> > >> net/ceph/messenger_v1.c:1099:23: warning: Boolean result is used in bitwise operation. Clarify expression with parentheses. [clarifyCondition]
> >      BUG_ON(!con->in_msg ^ skip);
> >                          ^
> >
> > vim +1099 net/ceph/messenger_v1.c
> >
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1033  static int read_partial_message(struct ceph_connection *con)
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1034  {
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1035          struct ceph_msg *m = con->in_msg;
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1036          int size;
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1037          int end;
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1038          int ret;
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1039          unsigned int front_len, middle_len, data_len;
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1040          bool do_datacrc = !ceph_test_opt(from_msgr(con->msgr), NOCRC);
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1041          bool need_sign = (con->peer_features & CEPH_FEATURE_MSG_AUTH);
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1042          u64 seq;
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1043          u32 crc;
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1044
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1045          dout("read_partial_message con %p msg %p\n", con, m);
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1046
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1047          /* header */
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1048          size = sizeof (con->in_hdr);
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1049          end = size;
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1050          ret = read_partial(con, end, size, &con->in_hdr);
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1051          if (ret <= 0)
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1052                  return ret;
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1053
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1054          crc = crc32c(0, &con->in_hdr, offsetof(struct ceph_msg_header, crc));
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1055          if (cpu_to_le32(crc) != con->in_hdr.crc) {
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1056                  pr_err("read_partial_message bad hdr crc %u != expected %u\n",
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1057                         crc, con->in_hdr.crc);
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1058                  return -EBADMSG;
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1059          }
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1060
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1061          front_len = le32_to_cpu(con->in_hdr.front_len);
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1062          if (front_len > CEPH_MSG_MAX_FRONT_LEN)
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1063                  return -EIO;
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1064          middle_len = le32_to_cpu(con->in_hdr.middle_len);
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1065          if (middle_len > CEPH_MSG_MAX_MIDDLE_LEN)
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1066                  return -EIO;
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1067          data_len = le32_to_cpu(con->in_hdr.data_len);
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1068          if (data_len > CEPH_MSG_MAX_DATA_LEN)
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1069                  return -EIO;
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1070
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1071          /* verify seq# */
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1072          seq = le64_to_cpu(con->in_hdr.seq);
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1073          if ((s64)seq - (s64)con->in_seq < 1) {
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1074                  pr_info("skipping %s%lld %s seq %lld expected %lld\n",
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1075                          ENTITY_NAME(con->peer_name),
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1076                          ceph_pr_addr(&con->peer_addr),
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1077                          seq, con->in_seq + 1);
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1078                  con->in_base_pos = -front_len - middle_len - data_len -
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1079                          sizeof_footer(con);
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1080                  con->in_tag = CEPH_MSGR_TAG_READY;
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1081                  return 1;
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1082          } else if ((s64)seq - (s64)con->in_seq > 1) {
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1083                  pr_err("read_partial_message bad seq %lld expected %lld\n",
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1084                         seq, con->in_seq + 1);
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1085                  con->error_msg = "bad message sequence # for incoming message";
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1086                  return -EBADE;
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1087          }
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1088
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1089          /* allocate message? */
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1090          if (!con->in_msg) {
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1091                  int skip = 0;
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1092
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1093                  dout("got hdr type %d front %d data %d\n", con->in_hdr.type,
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1094                       front_len, data_len);
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1095                  ret = ceph_con_in_msg_alloc(con, &con->in_hdr, &skip);
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1096                  if (ret < 0)
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1097                          return ret;
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1098
> > 2f713615ddd9d805 Ilya Dryomov 2020-11-12 @1099                  BUG_ON(!con->in_msg ^ skip);
> >
> > ! has higher precedence than ^.  It's not clear that was intended
> > necessarily.
> 
> Hi Dan,
> 
> This line and the surrounding code date back to 2013, commit
> 2f713615ddd9 just moved it.  It is correct (we either get a message
> to work with or get instructed to skip, in the latter case con->in_msg
> is expected to be NULL), so I'm inclined to leave it as is.

You could silence the warning and make the code look more intentional
by writing it like this:

	BUG_ON((!con->in_msg) ^ skip);

regards,
dan carpenter

