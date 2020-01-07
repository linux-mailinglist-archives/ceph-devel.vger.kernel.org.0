Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 126741333D2
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Jan 2020 22:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbgAGVDK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Jan 2020 16:03:10 -0500
Received: from mout.kundenserver.de ([212.227.126.135]:33875 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728865AbgAGVDI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Jan 2020 16:03:08 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MK3eI-1j87qh1y5m-00LZCF; Tue, 07 Jan 2020 22:02:57 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Oleksandr Natalenko <oleksandr@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        Jason Dillaman <dillaman@redhat.com>,
        David Howells <dhowells@redhat.com>,
        ceph-devel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rbd: work around -Wuninitialized warning
Date:   Tue,  7 Jan 2020 22:01:04 +0100
Message-Id: <20200107210256.2426176-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:qiBbNdWqGEMMIERlxqJELgdKzb8bJCMzjAWQ9HTgak9Ff2vxvog
 ZiKQ150VLDh9JWrAZooVqHelJQp11Bcb1+CNXSqkQDQ5sRKJxbgEOWMtteK73DtHqmRyONM
 XuUfU69io62lViiPJ2aYJR+QXe300SyxvfaTS/q7SZo+/bVQOrCU4ddHNeGOxxBML+IUjtl
 YruDPJn/MY3pY8Cm3Ekbw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:hziPz/VrV88=:vbym4h2BXvC60iOZqV3c2h
 O1BEGbiDBe0xht86RpkPm2j0b5Aq9nP58yihvmdmaAs52YAMUFSJQN6lDS5neHyMnJ8CwhTyp
 q/rUixeG4V50J54isuCECu+RaMN07YIVtYmZvSEIi7x//EvUSwn6U0Lp2n0nVWL61KTKeUK5w
 bL1Pi3P8Ox+LtG23J3WdbLl6E4SPfOLwY1ikjkvmalIdpPCNR7lAcTG3V69SGee1CyIvLD+47
 k3ByUp5plwat6dkBTeybDsS7BeOlk+ifWhyhS4brik6DBWh9gkd1GdTGLwsW7db43hNj1lnIv
 0LM7pwxPT0QkX2dHM5R/yhB/YZFNz9Sjrys2YjpseeiESAvU/6bbOJtpakDVhHUODCv+08sN6
 WXkkcXsNc3lBp8AIvhlpjYv2bUyMaLakFP+A+0TP5bvSd1bgdhpJFLxe15QA85rfnVhZI11vk
 wqUOtz3j4YBROukCc3nky2cbvIrab/mS+eiZBdkbPLo6Zau/Z7mZR1ZWu8AOH+ra1mUCN0/MC
 osU6Gm2s6foPtPQsSkeP5Eo7/xVdSfyYQz4eVc2pOCS7IBm+6PYaotTcweBIcKfDoemjlimBj
 JwT1w1u0iW5U/+Cb0PSw2IEkxma7HutNJlAbKqOID4TwiKXfIOlK7umbn/NpWSlTgh8X7H0+U
 upd5CbeWgqxJVNAI5bNOTL4WsTdDmcKUkxS1ezhMi/4WllLaHkV1A/KAZTsa6DIWXLwR6w0fu
 anNIdc9Z35OIyHFmhn/4oEUM93rSg8co0ZrKCI9uXiEJzQU4mPH/ve3QLrQ5Hy5LO+9T3xqOF
 +rOFy+C8Yi7a1h56k44qj5gbp1eBFwMVG33nWa6NciNxm3PYswLJ/eCpea1WdD6UkN76PQn2e
 LkkHj/b+AE4EjXP1YI5g==
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

gcc -O3 warns about a dummy variable that is passed
down into rbd_img_fill_nodata without being initialized:

drivers/block/rbd.c: In function 'rbd_img_fill_nodata':
drivers/block/rbd.c:2573:13: error: 'dummy' is used uninitialized in this function [-Werror=uninitialized]
  fctx->iter = *fctx->pos;

Since this is a dummy, I assume the warning is harmless, but
it's better to initialize it anyway and avoid the warning.

Fixes: mmtom ("init/Kconfig: enable -O3 for all arches")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/block/rbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 29be02838b67..070edc5983df 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -2664,7 +2664,7 @@ static int rbd_img_fill_nodata(struct rbd_img_request *img_req,
 			       u64 off, u64 len)
 {
 	struct ceph_file_extent ex = { off, len };
-	union rbd_img_fill_iter dummy;
+	union rbd_img_fill_iter dummy = {};
 	struct rbd_img_fill_ctx fctx = {
 		.pos_type = OBJ_REQUEST_NODATA,
 		.pos = &dummy,
-- 
2.20.0

