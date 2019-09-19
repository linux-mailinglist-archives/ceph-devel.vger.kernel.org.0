Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A76DCB73B2
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Sep 2019 09:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387782AbfISHGG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 19 Sep 2019 03:06:06 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44515 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387611AbfISHGG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 19 Sep 2019 03:06:06 -0400
Received: by mail-lj1-f193.google.com with SMTP id m13so2388940ljj.11
        for <ceph-devel@vger.kernel.org>; Thu, 19 Sep 2019 00:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=ceDNX4Ub1qGFtJMawhIizXcWlWEuKqM4ifvARNNnMjQ=;
        b=nuuw3lygvea72Oet2KV+wj1n7DjNGMu/c79VM8PbSMSUYPz/itbrfMchATHCkBHlxg
         pnOyY62Gp936f0VNnjxxM21L01VIA9CkAZ84ut+3jPJ00FdeaQrs59ap9y86lLwBgYyJ
         1E15ISKikT7Q1aA0iC12Erpii28ri56RpwjqDV3Q9vpcUoZ6eWNpFcz/UA8Fad/LYQgd
         n0viMpGyGuRPKDgzCyGnV6EmP3BMGnrRk9hkt6DhrPDOhAKAzVHvOd8eT76n1qdVlzcO
         60LiWwDN9Ag4xEO5es4zXtpQsVNoaHXmioqQDWmRV6ONjfZ8fF3DhOAt4SLUFI70rixm
         VfaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ceDNX4Ub1qGFtJMawhIizXcWlWEuKqM4ifvARNNnMjQ=;
        b=EgGBaMGnRmwovLnwEvTsz9ghSQt0yjz8r67luhDqTsC2MkWiJtJYKNrrkcHrZYntvL
         egDp+Phazcj1MR4xNcLSvXP4cXqFJppqJb7YahV5tOEXZ7xnGB+lXAZpA0ymuWfySkTG
         FV/oC1v8LS9PnwuMX2Yf5LHFcStVMGaISSu+CjPt+kKBXyEHYew0OkYbV7lknPO/Cvtq
         zGp96vJw5EApLmsSBYicf151nAxVNKIobfUaqbs3yudUIxaRTIDdp1AYUBC6MpYpX+6+
         UcZQ8aPXcm3Ye7EVSYpkY+ZGiNjQNiuECIjkRtWVe0YicB91x/DFqEKSpi6anALXeIKe
         V8Ng==
X-Gm-Message-State: APjAAAVnqJEY64gpUeIOhKTR9qlNozvDs+rY2dV/A+DsM452G+4e8VU5
        s3kGM2hq7Cccjm6iNuhAOh2QFuyd9pmoTHypFyGlmTCSqpc=
X-Google-Smtp-Source: APXvYqwUw17GGTMfEZdqTnQaU+DiR7RG7Ho3w4HG49DOMGOHvBsN3plVX49UJjm9h2URMEFipoJrk6TJO+uA830mE8c=
X-Received: by 2002:a2e:9094:: with SMTP id l20mr661387ljg.35.1568876763578;
 Thu, 19 Sep 2019 00:06:03 -0700 (PDT)
MIME-Version: 1.0
From:   Alex Xu <alexu4993@gmail.com>
Date:   Thu, 19 Sep 2019 15:05:52 +0800
Message-ID: <CAPHfcngzug4HDzHtZcb80xdf-NZFNjc2Q7r3vJWSHJufjcgKKQ@mail.gmail.com>
Subject: RADOS EC: is it okay to reduce the number of commits required for
 reply to client?
To:     ceph-devel@vger.kernel.org, ceph-users@lists.ceph.com
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Cephers,

We are testing the write performance of Ceph EC (Luminous, 8 + 4), and
noticed that tail latency is extremly high. Say, avgtime of 10th
commit is 40ms, acceptable as it's an all HDD cluster; 11th is 80ms,
doubled; then 12th is 160ms, doubled again, which is not so good. Then
we made a small modification and tested again, and did get a much
better result. The patch is quite simple (for test only of course):

--- a/src/osd/ECBackend.cc
+++ b/src/osd/ECBackend.cc
@@ -1188,7 +1188,7 @@ void ECBackend::handle_sub_write_reply(
     i->second.on_all_applied = 0;
     i->second.trace.event("ec write all applied");
   }
-  if (i->second.pending_commit.empty() && i->second.on_all_commit) {
+  if (i->second.pending_commit.size() == 2 &&
i->second.on_all_commit) {  // 8 + 4 - 10 = 2
     dout(10) << __func__ << " Calling on_all_commit on " << i->second << dendl;
     i->second.on_all_commit->complete(0);
     i->second.on_all_commit = 0;

As far as what I see, everything still goes well (maybe because of the
rwlock in primary OSD? not sure though), but I'm afraid it might break
data consistency in some ways not aware of. So I'm writing to ask if
someone could kindly provide expertise comments on this or maybe share
any known drawbacks. Thank you!

PS: OSD is backended with filestore, not bluestore, if that matters.

Regards,
Alex
