Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC655522F
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jun 2019 16:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730880AbfFYOlJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jun 2019 10:41:09 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34897 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730689AbfFYOlJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jun 2019 10:41:09 -0400
Received: by mail-wm1-f68.google.com with SMTP id c6so3271149wml.0
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jun 2019 07:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F8s80qDW5v8WSb1BrGgECAhE7AQt+YfMFe6a9Frvf54=;
        b=fA19RUAmQcXrdoakMBLN97yNYJT784ekNrSboKkZjzIyV91GEpSFhCDIfpU5PqG1ff
         I+cfURSgVqVkiS2UH4gzMxCsahUCuS5CtTCSlxrsRHGAW/Uhjwm5EZdwghS/3hOyghWy
         Jzzd1+oZtqog2bvxahcfnpVR7Qxiem+siDYVWGK0WmSuSYyIxOrIqql97Mll4wZKAEDT
         ZfylY7aSupWE1oBGyx1JE5esqe23OPOCfV3R3SjEGnry6sH7P7sdLlGYNFQySq0ZFjLq
         o1wgcmcNprSgCn1v/Ho80crz0MyzWl+iujkNXt0+8Ho1RSVStmxldjS3zjkZBnaKagKF
         OA0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F8s80qDW5v8WSb1BrGgECAhE7AQt+YfMFe6a9Frvf54=;
        b=ebzWI8230cG/UyKqBCBcATBfsQLzMymTXS+YO/x7aK2Cose8fL/wmf60U6NbKQP2+N
         hjSB61x9GTo/RZWfZer2+s7Ornstlpljz/ar6PXagov+GLLzSefqt7GVqLapKAc5EZGx
         +OpRa2cK9nK/3xZJzehhi3ZwTUKJrbKHiMQwP0LVWmTRD6kBElCjxfrX/4GZycQmJOKt
         o8sMUt6XuyJGcd2s0Bei582fw22k0cN6JYfgiRGX7NS7L0+OTyiYAAZdiyF65fjTO9Du
         SdbJ+Gk6EuqgaeO3AhcNcQs3axxiRbdA/sa1FpTjFs0eFX8cnX6COWqLdBXcE1I+84dJ
         nuxA==
X-Gm-Message-State: APjAAAXT1foPtfip1yHgGEIz/AH3sPwScQ2Ui+R5h4A2vSxiRIOR2axH
        a/Eabiz4aFIsTjFDN/0eVvL8LTTWoog=
X-Google-Smtp-Source: APXvYqxSfYzrbqvAHUw/AoBDA7Ny+W5XcX8mVXVX7vznCua/8xnGn5wfVhr6994+b58GBgTflJGcTA==
X-Received: by 2002:a1c:b6d4:: with SMTP id g203mr19916656wmf.19.1561473667002;
        Tue, 25 Jun 2019 07:41:07 -0700 (PDT)
Received: from kwango.redhat.com (ovpn-brq.redhat.com. [213.175.37.11])
        by smtp.gmail.com with ESMTPSA id f2sm20282378wrq.48.2019.06.25.07.41.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 07:41:06 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 00/20] rbd: support for object-map and fast-diff
Date:   Tue, 25 Jun 2019 16:40:51 +0200
Message-Id: <20190625144111.11270-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello,

This series adds support for object-map and fast-diff image features.
Patches 1 - 11 prepare object and image request state machines; patches
12 - 14 fix most of the shortcomings in our exclusive lock code, making
it suitable for guarding the object map; patches 15 - 18 take care of
the prerequisites and finally patches 19 - 20 implement object-map and
fast-diff.

Thanks,

                Ilya


Ilya Dryomov (20):
  rbd: get rid of obj_req->xferred, obj_req->result and img_req->xferred
  rbd: replace obj_req->tried_parent with obj_req->read_state
  rbd: get rid of RBD_OBJ_WRITE_{FLAT,GUARD}
  rbd: move OSD request submission into object request state machines
  rbd: introduce image request state machine
  rbd: introduce obj_req->osd_reqs list
  rbd: factor out rbd_osd_setup_copyup()
  rbd: factor out __rbd_osd_setup_discard_ops()
  rbd: move OSD request allocation into object request state machines
  rbd: rename rbd_obj_setup_*() to rbd_obj_init_*()
  rbd: introduce copyup state machine
  rbd: lock should be quiesced on reacquire
  rbd: quiescing lock should wait for image requests
  rbd: new exclusive lock wait/wake code
  libceph: bump CEPH_MSG_MAX_DATA_LEN (again)
  libceph: change ceph_osdc_call() to take page vector for response
  libceph: export osd_req_op_data() macro
  rbd: call rbd_dev_mapping_set() from rbd_dev_image_probe()
  rbd: support for object-map and fast-diff
  rbd: setallochint only if object doesn't exist

 drivers/block/rbd.c                  | 2433 ++++++++++++++++++--------
 drivers/block/rbd_types.h            |   10 +
 include/linux/ceph/cls_lock_client.h |    3 +
 include/linux/ceph/libceph.h         |    6 +-
 include/linux/ceph/osd_client.h      |   10 +-
 include/linux/ceph/striper.h         |    2 +
 net/ceph/cls_lock_client.c           |   47 +-
 net/ceph/osd_client.c                |   18 +-
 net/ceph/striper.c                   |   17 +
 9 files changed, 1817 insertions(+), 729 deletions(-)

-- 
2.19.2

