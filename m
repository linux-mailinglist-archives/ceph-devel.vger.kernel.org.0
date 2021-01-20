Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62EB32FD171
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Jan 2021 14:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389041AbhATMgI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Jan 2021 07:36:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731352AbhATLC5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 20 Jan 2021 06:02:57 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A18FC061575;
        Wed, 20 Jan 2021 03:01:47 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id d13so42774454ioy.4;
        Wed, 20 Jan 2021 03:01:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L+IuBTQtieqaT+RwFnqYJbcf3g6vdNyCnN2MiBzAXBE=;
        b=RBbs6zIZczLTU2w8yjiug6EgsOcd9gNaGOCCe0mrqg6PDvRCwumhKYIGDcNNBelC0r
         Jw2uH8crESjpMHW9SZCBzcPjSONexWHjeGmi26S8WWU0fs3+r+phtFPbhvZb8WMPY0hx
         M0wgpnfVF1Kq00UVy0qfVpJ754lyIbhwPP/sUGMpqz2gVfFVHEd8jdxuEjs9TKAxpC9s
         CPFceo01nDHUm2vkbZ4tG9S97roi4+tbVpNe4kgUNjKrBgUGdLhPhDEV1A/wTzt+WA3U
         CPjQJeedKBCbpFvJmc9iIS19KmmnM+y2s3ch0DS4Jf2YLDqSXTenb09E/OmH++20HglT
         RCRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L+IuBTQtieqaT+RwFnqYJbcf3g6vdNyCnN2MiBzAXBE=;
        b=mg4BimVXD/Y99Sey6eiXEMy8DufjMhntUCYFNk8UvM5B8V82UC3i0ENQN+iNTQV6Jo
         RSswpQL+zV/FLT/DBte6XM6xp+Av+PFGY4U8lDIhYXwZcX4oPKBpQepSD2OZBPiBlS3H
         /hb44IsG8Wocp36dvSGQJo1PGme2ETltalRFdx5ygfYo9rJzx+49m3PNskUqENLAfj9W
         VoCNfOh1mCJtGf1E6StnSNFW19SiuvQjRUmtx3vCb77U51bzBC5qesFQLlZTQXjOl9NV
         OzpFlrSPHweww+Y/m7nmjOcp+0FMUeUoJXKmoIoZjiZO4eEmvafacs5zt/gEtI2jZDv8
         bQyw==
X-Gm-Message-State: AOAM532TLfeE3dvj3+YJBVvyAGqCsTEruVx3y601GaQoG1ucTif8hekJ
        IMZvYJLkz24g+Y42pgF7PiwzPvTEgXYJYBTdDvg=
X-Google-Smtp-Source: ABdhPJymzK3wPrNevSHmVMS1UuQOIEYzZqh9echOATw1rO+7elhN62r/NWs4kXRZmBvlUELy+5b3qOOQzmdj6w3PiLU=
X-Received: by 2002:a05:6e02:1566:: with SMTP id k6mr7215915ilu.19.1611140506416;
 Wed, 20 Jan 2021 03:01:46 -0800 (PST)
MIME-Version: 1.0
References: <20210119194646.GA20820@kadam>
In-Reply-To: <20210119194646.GA20820@kadam>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 20 Jan 2021 12:01:59 +0100
Message-ID: <CAOi1vP-7AYWiJJganaUROaGiyJA8ejUmbx90uetwsV23KYGNFw@mail.gmail.com>
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

On Tue, Jan 19, 2021 at 8:46 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git  master
> head:   1e2a199f6ccdc15cf111d68d212e2fd4ce65682e
> commit: 2f713615ddd9d805b6c5e79c52e0e11af99d2bf1 libceph: move msgr1 protocol implementation to its own file
> compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
>
> cppcheck possible warnings: (new ones prefixed by >>, may not real problems)
>
> >> net/ceph/messenger_v1.c:1099:23: warning: Boolean result is used in bitwise operation. Clarify expression with parentheses. [clarifyCondition]
>      BUG_ON(!con->in_msg ^ skip);
>                          ^
>
> vim +1099 net/ceph/messenger_v1.c
>
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1033  static int read_partial_message(struct ceph_connection *con)
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1034  {
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1035          struct ceph_msg *m = con->in_msg;
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1036          int size;
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1037          int end;
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1038          int ret;
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1039          unsigned int front_len, middle_len, data_len;
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1040          bool do_datacrc = !ceph_test_opt(from_msgr(con->msgr), NOCRC);
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1041          bool need_sign = (con->peer_features & CEPH_FEATURE_MSG_AUTH);
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1042          u64 seq;
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1043          u32 crc;
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1044
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1045          dout("read_partial_message con %p msg %p\n", con, m);
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1046
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1047          /* header */
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1048          size = sizeof (con->in_hdr);
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1049          end = size;
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1050          ret = read_partial(con, end, size, &con->in_hdr);
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1051          if (ret <= 0)
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1052                  return ret;
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1053
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1054          crc = crc32c(0, &con->in_hdr, offsetof(struct ceph_msg_header, crc));
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1055          if (cpu_to_le32(crc) != con->in_hdr.crc) {
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1056                  pr_err("read_partial_message bad hdr crc %u != expected %u\n",
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1057                         crc, con->in_hdr.crc);
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1058                  return -EBADMSG;
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1059          }
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1060
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1061          front_len = le32_to_cpu(con->in_hdr.front_len);
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1062          if (front_len > CEPH_MSG_MAX_FRONT_LEN)
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1063                  return -EIO;
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1064          middle_len = le32_to_cpu(con->in_hdr.middle_len);
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1065          if (middle_len > CEPH_MSG_MAX_MIDDLE_LEN)
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1066                  return -EIO;
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1067          data_len = le32_to_cpu(con->in_hdr.data_len);
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1068          if (data_len > CEPH_MSG_MAX_DATA_LEN)
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1069                  return -EIO;
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1070
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1071          /* verify seq# */
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1072          seq = le64_to_cpu(con->in_hdr.seq);
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1073          if ((s64)seq - (s64)con->in_seq < 1) {
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1074                  pr_info("skipping %s%lld %s seq %lld expected %lld\n",
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1075                          ENTITY_NAME(con->peer_name),
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1076                          ceph_pr_addr(&con->peer_addr),
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1077                          seq, con->in_seq + 1);
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1078                  con->in_base_pos = -front_len - middle_len - data_len -
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1079                          sizeof_footer(con);
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1080                  con->in_tag = CEPH_MSGR_TAG_READY;
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1081                  return 1;
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1082          } else if ((s64)seq - (s64)con->in_seq > 1) {
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1083                  pr_err("read_partial_message bad seq %lld expected %lld\n",
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1084                         seq, con->in_seq + 1);
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1085                  con->error_msg = "bad message sequence # for incoming message";
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1086                  return -EBADE;
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1087          }
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1088
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1089          /* allocate message? */
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1090          if (!con->in_msg) {
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1091                  int skip = 0;
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1092
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1093                  dout("got hdr type %d front %d data %d\n", con->in_hdr.type,
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1094                       front_len, data_len);
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1095                  ret = ceph_con_in_msg_alloc(con, &con->in_hdr, &skip);
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1096                  if (ret < 0)
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1097                          return ret;
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12  1098
> 2f713615ddd9d805 Ilya Dryomov 2020-11-12 @1099                  BUG_ON(!con->in_msg ^ skip);
>
> ! has higher precedence than ^.  It's not clear that was intended
> necessarily.

Hi Dan,

This line and the surrounding code date back to 2013, commit
2f713615ddd9 just moved it.  It is correct (we either get a message
to work with or get instructed to skip, in the latter case con->in_msg
is expected to be NULL), so I'm inclined to leave it as is.

Thanks,

                Ilya
