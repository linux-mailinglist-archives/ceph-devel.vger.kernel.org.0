Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20ACD7C7E3A
	for <lists+ceph-devel@lfdr.de>; Fri, 13 Oct 2023 08:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjJMGzj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 13 Oct 2023 02:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbjJMGzi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 13 Oct 2023 02:55:38 -0400
Received: from jari.cn (unknown [218.92.28.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 61A13F1;
        Thu, 12 Oct 2023 23:55:35 -0700 (PDT)
Received: from wangkailong$jari.cn ( [182.148.14.172] ) by
 ajax-webmail-localhost.localdomain (Coremail) ; Fri, 13 Oct 2023 14:53:53
 +0800 (GMT+08:00)
X-Originating-IP: [182.148.14.172]
Date:   Fri, 13 Oct 2023 14:53:53 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   "KaiLong Wang" <wangkailong@jari.cn>
To:     xiubli@redhat.com, idryomov@gmail.com, jlayton@kernel.org
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ceph: Clean up errors in mdsmap.c
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.1-cmXT6 build
 20230419(ff23bf83) Copyright (c) 2002-2023 www.mailtech.cn
 mispb-4e503810-ca60-4ec8-a188-7102c18937cf-zhkzyfz.cn
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <5722ebe7.95d.18b27d0200e.Coremail.wangkailong@jari.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: AQAAfwDXaD6B6ShlYt7BAA--.631W
X-CM-SenderInfo: 5zdqwypdlo00nj6mt2flof0/1tbiAQABB2UlHDMAlgARsv
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=3.4 required=5.0 tests=BAYES_00,RCVD_IN_PBL,RDNS_NONE,
        T_SPF_HELO_PERMERROR,T_SPF_PERMERROR,XPRIO autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Rml4IHRoZSBmb2xsb3dpbmcgZXJyb3JzIHJlcG9ydGVkIGJ5IGNoZWNrcGF0Y2g6CgpFUlJPUjog
ImZvbyogYmFyIiBzaG91bGQgYmUgImZvbyAqYmFyIgpFUlJPUjogc3BhY2VzIHJlcXVpcmVkIGFy
b3VuZCB0aGF0ICc9JyAoY3R4OlZ4VykKClNpZ25lZC1vZmYtYnk6IEthaUxvbmcgV2FuZyA8d2Fu
Z2thaWxvbmdAamFyaS5jbj4KLS0tCiBmcy9jZXBoL21kc21hcC5jIHwgNCArKy0tCiAxIGZpbGUg
Y2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Zz
L2NlcGgvbWRzbWFwLmMgYi9mcy9jZXBoL21kc21hcC5jCmluZGV4IDdkYWMyMWVlNmNlNy4uYmI1
OTZlMDBmZDljIDEwMDY0NAotLS0gYS9mcy9jZXBoL21kc21hcC5jCisrKyBiL2ZzL2NlcGgvbWRz
bWFwLmMKQEAgLTgyLDcgKzgyLDcgQEAgaW50IGNlcGhfbWRzbWFwX2dldF9yYW5kb21fbWRzKHN0
cnVjdCBjZXBoX21kc21hcCAqbSkKIAl9IHdoaWxlICgwKQogCiAKLXN0YXRpYyBpbnQgX19kZWNv
ZGVfYW5kX2Ryb3BfY29tcGF0X3NldCh2b2lkICoqcCwgdm9pZCogZW5kKQorc3RhdGljIGludCBf
X2RlY29kZV9hbmRfZHJvcF9jb21wYXRfc2V0KHZvaWQgKipwLCB2b2lkICplbmQpCiB7CiAJaW50
IGk7CiAJLyogY29tcGF0LCByb19jb21wYXQsIGluY29tcGF0Ki8KQEAgLTE4Niw3ICsxODYsNyBA
QCBzdHJ1Y3QgY2VwaF9tZHNtYXAgKmNlcGhfbWRzbWFwX2RlY29kZSh2b2lkICoqcCwgdm9pZCAq
ZW5kLCBib29sIG1zZ3IyKQogCiAJCWNlcGhfZGVjb2RlX25lZWQocCwgZW5kLCBzaXplb2YodTY0
KSArIDEsIGJhZCk7CiAJCWdsb2JhbF9pZCA9IGNlcGhfZGVjb2RlXzY0KHApOwotCQlpbmZvX3Y9
IGNlcGhfZGVjb2RlXzgocCk7CisJCWluZm9fdiA9IGNlcGhfZGVjb2RlXzgocCk7CiAJCWlmIChp
bmZvX3YgPj0gNCkgewogCQkJdTMyIGluZm9fbGVuOwogCQkJY2VwaF9kZWNvZGVfbmVlZChwLCBl
bmQsIDEgKyBzaXplb2YodTMyKSwgYmFkKTsKLS0gCjIuMTcuMQo=
