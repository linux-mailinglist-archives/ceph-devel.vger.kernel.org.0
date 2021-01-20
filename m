Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412E72FD276
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Jan 2021 15:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733206AbhATOPg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Jan 2021 09:15:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728260AbhATMxU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 20 Jan 2021 07:53:20 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE705C0617A0;
        Wed, 20 Jan 2021 04:52:31 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id q129so1719089iod.0;
        Wed, 20 Jan 2021 04:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mDrqwwi/dX0UvEoclax7LgTw2g4Rm/2kH937xyj0jFY=;
        b=VRm6nWoKO8BivPQ+PvjXBYFH/JZd/M7ksUviOMgreEa70nRIFLrMcgz+jGnH3pYxBr
         zC1f8oTrPAPZyUKV/PlOceHtgPiFPUiQPGdaEF5fQjPPMjgh4gp830zpX8hmZ7+q7Gka
         p2/osE8OiBOgOmeBNM4fcv64NEWmlay8YuimT54vspxX81LkU4+hSm48kagJ824AtbfH
         SBdA1wbNfGe3hiCN9CONjNegEZg5uS3c/r2WO9+XrPmjaLr9VnpG0T8NgsFqMKkCDY6r
         BdCfT3kZpBXbZgJ4mUMyHCc3+mE2UKdLntJz705Me/LzN3102sSNVT5M0ooUkipQeYLu
         sc8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mDrqwwi/dX0UvEoclax7LgTw2g4Rm/2kH937xyj0jFY=;
        b=eDU6hMdFtYJPGL/IGcp5lwItdEaw6fP/DlEYUrTc0wid1cSO12Q2snTDS/+qArwwXS
         qqVQ9z2q8MOgq5xC+633rv/6xxRwT8//ZQWZq3JN11oUJELt0djAVbh2dDRZAItWoBn8
         FBMhYqIOAkL2+anzxJxPkg3EiU3OtfN/mBPPuV2bmMiwVC7s2Mt7/qkk+CmrpMDZ89eY
         /hQMosFcTpKJYVasPXf1YYDIHzddg1K7PM9tXtEvEnMFlEpBRqDKjPAuFuALK3vsNQ2y
         YQhVx22V3T9tCUyk7THKnMo48yzpILDy5dureLjEcwhg10penei6vUT6FM5GNhdIVsci
         P+1g==
X-Gm-Message-State: AOAM5331qXyEvujsAH4q8qgMzwTMa7J/IwYMD+EaTdOMDNUsiPrnw+r5
        7JhZz9YUEZeAoF0DildjO6YPHmlFYd61eV1n4qNUKglTO1o=
X-Google-Smtp-Source: ABdhPJxg1NwPxjor6VKmK+ViC4KtJb5QWaHzv+IAugESAvfZHGHhHEpDv9QNboP7BRa25MqN6G0jJPKDaWXkcT4AdI4=
X-Received: by 2002:a92:5e04:: with SMTP id s4mr7630802ilb.100.1611147151192;
 Wed, 20 Jan 2021 04:52:31 -0800 (PST)
MIME-Version: 1.0
References: <20210119194646.GA20820@kadam> <CAOi1vP-7AYWiJJganaUROaGiyJA8ejUmbx90uetwsV23KYGNFw@mail.gmail.com>
 <20210120124055.GG20820@kadam>
In-Reply-To: <20210120124055.GG20820@kadam>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 20 Jan 2021 13:52:44 +0100
Message-ID: <CAOi1vP_Zx2WrujeAa6+n615eFTMSost7qnzjWMQETQvKamKDug@mail.gmail.com>
Subject: Re: [kbuild] net/ceph/messenger_v1.c:1099:23: warning: Boolean result
 is used in bitwise operation. Clarify expression with parentheses.
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kbuild@lists.01.org, kbuild test robot <lkp@intel.com>,
        kbuild-all@lists.01.org, LKML <linux-kernel@vger.kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jan 20, 2021 at 1:43 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> On Wed, Jan 20, 2021 at 12:01:59PM +0100, Ilya Dryomov wrote:
> > On Tue, Jan 19, 2021 at 8:46 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > >
> > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git   master
> > > head:   1e2a199f6ccdc15cf111d68d212e2fd4ce65682e
> > > commit: 2f713615ddd9d805b6c5e79c52e0e11af99d2bf1 libceph: move msgr1 protocol implementation to its own file
> > > compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
> > >
> > > If you fix the issue, kindly add following tag as appropriate
> > > Reported-by: kernel test robot <lkp@intel.com>
> > >
> > >
> > > cppcheck possible warnings: (new ones prefixed by >>, may not real problems)
> > >
> > > >> net/ceph/messenger_v1.c:1099:23: warning: Boolean result is used in bitwise operation. Clarify expression with parentheses. [clarifyCondition]
> > >      BUG_ON(!con->in_msg ^ skip);
> > >                          ^
> > >
> > > vim +1099 net/ceph/messenger_v1.c
> > >
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1033  static int read_partial_message(struct ceph_connection *con)
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1034  {
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1035          struct ceph_msg *m = con->in_msg;
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1036          int size;
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1037          int end;
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1038          int ret;
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1039          unsigned int front_len, middle_len, data_len;
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1040          bool do_datacrc = !ceph_test_opt(from_msgr(con->msgr), NOCRC);
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1041          bool need_sign = (con->peer_features & CEPH_FEATURE_MSG_AUTH);
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1042          u64 seq;
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1043          u32 crc;
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1044
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1045          dout("read_partial_message con %p msg %p\n", con, m);
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1046
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1047          /* header */
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1048          size = sizeof (con->in_hdr);
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1049          end = size;
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1050          ret = read_partial(con, end, size, &con->in_hdr);
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1051          if (ret <= 0)
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1052                  return ret;
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1053
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1054          crc = crc32c(0, &con->in_hdr, offsetof(struct ceph_msg_header, crc));
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1055          if (cpu_to_le32(crc) != con->in_hdr.crc) {
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1056                  pr_err("read_partial_message bad hdr crc %u != expected %u\n",
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1057                         crc, con->in_hdr.crc);
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1058                  return -EBADMSG;
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1059          }
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1060
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1061          front_len = le32_to_cpu(con->in_hdr.front_len);
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1062          if (front_len > CEPH_MSG_MAX_FRONT_LEN)
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1063                  return -EIO;
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1064          middle_len = le32_to_cpu(con->in_hdr.middle_len);
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1065          if (middle_len > CEPH_MSG_MAX_MIDDLE_LEN)
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1066                  return -EIO;
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1067          data_len = le32_to_cpu(con->in_hdr.data_len);
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1068          if (data_len > CEPH_MSG_MAX_DATA_LEN)
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1069                  return -EIO;
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1070
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1071          /* verify seq# */
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1072          seq = le64_to_cpu(con->in_hdr.seq);
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1073          if ((s64)seq - (s64)con->in_seq < 1) {
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1074                  pr_info("skipping %s%lld %s seq %lld expected %lld\n",
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1075                          ENTITY_NAME(con->peer_name),
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1076                          ceph_pr_addr(&con->peer_addr),
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1077                          seq, con->in_seq + 1);
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1078                  con->in_base_pos = -front_len - middle_len - data_len -
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1079                          sizeof_footer(con);
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1080                  con->in_tag = CEPH_MSGR_TAG_READY;
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1081                  return 1;
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1082          } else if ((s64)seq - (s64)con->in_seq > 1) {
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1083                  pr_err("read_partial_message bad seq %lld expected %lld\n",
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1084                         seq, con->in_seq + 1);
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1085                  con->error_msg = "bad message sequence # for incoming message";
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1086                  return -EBADE;
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1087          }
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1088
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1089          /* allocate message? */
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1090          if (!con->in_msg) {
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1091                  int skip = 0;
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1092
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1093                  dout("got hdr type %d front %d data %d\n", con->in_hdr.type,
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1094                       front_len, data_len);
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1095                  ret = ceph_con_in_msg_alloc(con, &con->in_hdr, &skip);
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1096                  if (ret < 0)
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1097                          return ret;
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1098
> > > 2f713615ddd9d805 Ilya Dryomov 2020-11-12 @1099                  BUG_ON(!con->in_msg ^ skip);
> > >
> > > ! has higher precedence than ^.  It's not clear that was intended
> > > necessarily.
> >
> > Hi Dan,
> >
> > This line and the surrounding code date back to 2013, commit
> > 2f713615ddd9 just moved it.  It is correct (we either get a message
> > to work with or get instructed to skip, in the latter case con->in_msg
> > is expected to be NULL), so I'm inclined to leave it as is.
>
> You could silence the warning and make the code look more intentional
> by writing it like this:
>
>         BUG_ON((!con->in_msg) ^ skip);

OK, I'll do that.

Thanks,

                Ilya
