Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2882C446E1
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Jun 2019 18:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392851AbfFMQzN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Jun 2019 12:55:13 -0400
Received: from mail-qt1-f181.google.com ([209.85.160.181]:44561 "EHLO
        mail-qt1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730024AbfFMCGH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 12 Jun 2019 22:06:07 -0400
Received: by mail-qt1-f181.google.com with SMTP id x47so20768642qtk.11
        for <ceph-devel@vger.kernel.org>; Wed, 12 Jun 2019 19:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=fyx+3s4EUK88QjRF+Wurf+zD25KMcYIVyvXcOSyqAys=;
        b=ObxYenY92IdC5SeLlVis3D7M8EzWIo6crjdcX2y5ym5SXE3Dw02NsKfrSmsh8lQKZX
         BqsMhhNaIyrKMCuTgP++rIJQpMi/41h9whaeieTYRmIhOy/ljZG9TZXZyiqIxHebuKYq
         oUpq9Q8FTAhEeOzmhgMcqANPDHGrDbWD75GOhGJHlVBX0IQCoQzrX6SkMA+xduMIHVg/
         DvKm+xtBVTl975PCk5BWO0t+MpVpvzX76AFC2gSE03O8m/tIkbv3MMSClkZuTXWH9csA
         0lzofqqX/ZA60BwvuvFWhSElpSEQEGwo04ueDupvuslxhqSXq14SjGe0eCa4jVdahV4K
         cRiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=fyx+3s4EUK88QjRF+Wurf+zD25KMcYIVyvXcOSyqAys=;
        b=qW5L2K/QAaGl/3xYWsTgnrnPs+IeU14LnClYCLY+nRri/24JYveEbkFGzeWx+hG3aL
         qlY4KJIRQHf8GWLs7r3IMPXJw+ejlcj070gxac+RVT8VaegUZmmpwIVbRDDcjfprzMbt
         TVBcXK0y8QkqcrrjdMph7IpD7EZTt24/5s1zM/tKRBkEH1CxJXluW2bRFy4d4IE3LRXq
         H9J6ba69JgwwiIDSM19jVB+BjHjfaD/PbbhtOfPQLvxXUYBBwfcu2S25RMlLH3fQJuSO
         UXjGVwJufDyXUcPLRoBbPcyuRn4+gQraIanWj9610mgP29Ki2mz/MMyoUH8UaQsKee9T
         ikJw==
X-Gm-Message-State: APjAAAVHO8po44A1hd4becclIKFp2RavM2TQE6sT3G+GtULS7D25caVD
        Gwt5/liBQrg53gDGcN/UMGaBAxJbx4rd0EXKwngfWvsjyTk=
X-Google-Smtp-Source: APXvYqzcCHdGh9ta3FdGXFV3xemf7Ji1MTvBBp17DuoF6YAWvQwHy6FYURmTUJIJbBAuprdZuh1LmdoL+Jn4MC8Hlwo=
X-Received: by 2002:a0c:eecd:: with SMTP id h13mr1362270qvs.46.1560391565773;
 Wed, 12 Jun 2019 19:06:05 -0700 (PDT)
MIME-Version: 1.0
From:   huang jun <hjwsm1989@gmail.com>
Date:   Thu, 13 Jun 2019 10:05:53 +0800
Message-ID: <CABAwU-Zv1d1qT5n2-JEcm1vpK9XdTg30yzrhMoeQ2B4ujO=peA@mail.gmail.com>
Subject: ceph-monstore-tool rebuild question
To:     ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,all
I recently read the ceph-monstore-tool code, and have a question about
rebuild operations.
In update_paxos() we read  osdmap, pgmap, auth and pgmap_pg records to
pending_proposal(a bufferlist) as the value of  the key paxos_1, and
set paxos_pending_v=1,
and set the paxos_last_committed=0 and paxos_first_committed=0;

My question is if we start the mon after rebuild, let's say there is
only one mon now, the mon will not commit the paxos_pending_v=1, and
if we change the osdmap by 'ceph osd set noout' the new pending_v=1
will overwrite the former one in rebuild, so i think we don't need to
set paxos_1=pending_proposal, paxos_pending_v=1 in 'ceph-monstore-tool
rebuild'.

Thanks!
