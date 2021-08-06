Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174D03E2875
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Aug 2021 12:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245043AbhHFKTI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 6 Aug 2021 06:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245032AbhHFKTE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 6 Aug 2021 06:19:04 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9219AC061798
        for <ceph-devel@vger.kernel.org>; Fri,  6 Aug 2021 03:18:48 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so22049394pjr.1
        for <ceph-devel@vger.kernel.org>; Fri, 06 Aug 2021 03:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=+oHuXO9/SrgYmkGMX07ZJ2TpeHf3LrcOdeJmyOngO5o=;
        b=KxSmpRuWMoO5fRZwMXbgyDNofP+qW+srGiXlmqbyz9zvJcq+d4Oj7gyPsePZR65G/N
         v4nWipWkD1Q5THXGuztCvN9JiGuPivx37QXEvbeduf7ANotWmI2Vq8k60USeS7/HMNM5
         BfSVwRuw21XGGv0dXCouohTzajHBvnUDFSpp0UZF5UdE1odUFxnOPybZ2/ARzckt8IjA
         YpOyVXCwfU4skfzheKPJa0ItpgRMRBSjKmX4mNTKZyvMc7FlNXc3snw7npsLMqxpomuD
         kn1JK1dSYLdELC76CYoUrH/nXGLBTy65V/+N58hJaHiTF0DAhGxKPuHLzmnNqAVnwFIx
         Oe9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=+oHuXO9/SrgYmkGMX07ZJ2TpeHf3LrcOdeJmyOngO5o=;
        b=sF6yWe6xO2QCZ8QT/YYglbgohY9k13Q+rnLEv3WuLYSZaLYFIrJ75oGxY2VM+5mfzW
         iGnV2Yl/HLj5itZNTcwO/1qCwiCNKCqGb6PcERwaVSO4urkqLCM0nzlx7Rxhg4bw4EBR
         25WDyWM3tEXPeCayd7lnLNgtZQgv5he4SEppYXbq/ifN2LqhfNQ9Yuh6tBmAkbMtNfMG
         URqRuwStFBvrqgdZJo9XMBNiwePeizH0dr9SDiTRmhWiIePUjVsZDodlxUkO0Q9ydNbv
         7eBtyBCOeB3KHwhU6SAVYILvUxARWqdKgK/2m7QEkjgIUC8kAjinV3Hl0qOlYEjjw9Fh
         zigA==
X-Gm-Message-State: AOAM5323gcdTZJw2RbNMFBHPYuQgynOYLcF+UQlgI+lAZFzgovted0B+
        7cRIAnK/iZI82VQrc0Ggd7w0ODd/wWpLJcZJDEuKKqH6jaI=
X-Google-Smtp-Source: ABdhPJyKScJR+n7uG0zejvd7Xg1+op96Adk0SwKI3E/VAaGyUtxfS55wVSk7+XzJuAHlaAWslTNgC2rvt2OSciqyA/M=
X-Received: by 2002:a65:63c1:: with SMTP id n1mr975215pgv.398.1628245128009;
 Fri, 06 Aug 2021 03:18:48 -0700 (PDT)
MIME-Version: 1.0
From:   WeiGuo Ren <rwg1335252904@gmail.com>
Date:   Fri, 6 Aug 2021 18:18:24 +0800
Message-ID: <CAPy+zYUwvOap_yFY93PF+xvri-f1MwDRO2bZM=yyx21yedvegg@mail.gmail.com>
Subject: s3test: In ceph-nautilus branch , some fails_strict_rfc2616 test
 failed, Is this normal?
To:     Ceph Development <ceph-devel@vger.kernel.org>, ceph-users@ceph.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I want to test  test_object_create_bad_md5_unreadable. but rgw send
400(e.status),rather than 403.I dont understand it. The code is.
@tag('auth_common')
@attr(resource='object')
@attr(method='put')
@attr(operation='create w/non-graphics in MD5')
@attr(assertion='fails 403')
@attr('fails_strict_rfc2616')
@nose.with_setup(teardown=_clear_custom_headers)
def test_object_create_bad_md5_unreadable():
    key = _setup_bad_object({'Content-MD5': '\x07'})

    e = assert_raises(boto.exception.S3ResponseError,
key.set_contents_from_string, 'bar')
    eq(e.status, 403)
    eq(e.reason, 'Forbidden')
    assert e.error_code in ('AccessDenied', 'SignatureDoesNotMatch')
