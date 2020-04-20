Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40F41B0120
	for <lists+ceph-devel@lfdr.de>; Mon, 20 Apr 2020 07:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbgDTFrG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 20 Apr 2020 01:47:06 -0400
Received: from mail.fudan.edu.cn ([202.120.224.73]:41038 "EHLO fudan.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725971AbgDTFrF (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 20 Apr 2020 01:47:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id; bh=uzKBpRqWqrL68DjlrMLrFbymZnh9Mm1O4zM1L55rFDM=; b=i
        jNJwWS9MAEI9JD1IO0CNdyHUIpjdCp5dQvv+ORw2Jkjxzh7t1SbxiAOXTN76OEHx
        0m0OLF9y0UgWYedL1ITpz6MlrtmzmDOg+NyiN8VVYOmxEKftCe4gQ3rBlv6mnyMH
        wVZxHKN3NUXlrCY8eHDipk/ySmBr3YhNixXSk5GfCk=
Received: from localhost.localdomain (unknown [120.229.255.67])
        by app2 (Coremail) with SMTP id XQUFCgCnWOH6NZ1eM_odAA--.12310S3;
        Mon, 20 Apr 2020 13:41:16 +0800 (CST)
From:   Xiyu Yang <xiyuyang19@fudan.edu.cn>
To:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     yuanxzhang@fudan.edu.cn, kjlu@umn.edu,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: [PATCH] ceph: Fix potential ceph_osd_request refcnt leak
Date:   Mon, 20 Apr 2020 13:40:43 +0800
Message-Id: <1587361243-83431-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: XQUFCgCnWOH6NZ1eM_odAA--.12310S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ZrW5JFy5Cr47GryrJF1DKFg_yoW8Gryfpr
        47Cw4UtrsYq3W8XF4kJ398W348ua18ZrWSyr1FgFy8CFn5Xa9IyF1Fq3sIqr47AFyxJr95
        trs09r4DZa42yFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvm14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4U
        JVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
        0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr
        1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
        rcIFxwCY02Avz4vE14v_GrWl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr
        1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE
        14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7
        IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVW3JVWrJr1lIxAIcVC2
        z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnU
        UI43ZEXa7VU1U5r7UUUUU==
X-CM-SenderInfo: irzsiiysuqikmy6i3vldqovvfxof0/
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

ceph_writepages_start() invokes ceph_osdc_start_request(), which
increases the refcount of the ceph_osd_request object "req" and then
submit the request.

When ceph_writepages_start() returns or a new object is assigned to
"req", the original local reference of "req" becomes invalid, so the
refcount should be decreased to keep refcount balanced.

The reference counting issue happens in a normal path of
ceph_writepages_start(). Before NULL assigned to "req", the function
forgets to decrease its refcnt increased by ceph_osdc_start_request()
and will cause a refcnt leak.

Fix this issue by calling ceph_osdc_put_request() before the original
object pointed by "req" becomes invalid.

Fixes: 1d3576fd10f0 ("ceph: address space operations")
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
---
 fs/ceph/addr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 7ab616601141..b02c050a3418 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1126,6 +1126,7 @@ static int ceph_writepages_start(struct address_space *mapping,
 		req->r_mtime = inode->i_mtime;
 		rc = ceph_osdc_start_request(&fsc->client->osdc, req, true);
 		BUG_ON(rc);
+		ceph_osdc_put_request(req);
 		req = NULL;
 
 		wbc->nr_to_write -= i;
-- 
2.7.4

