Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA17F69F415
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Feb 2023 13:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbjBVMNO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 22 Feb 2023 07:13:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjBVMNN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 22 Feb 2023 07:13:13 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE527A87
        for <ceph-devel@vger.kernel.org>; Wed, 22 Feb 2023 04:13:12 -0800 (PST)
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com [209.85.128.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 02BBE3F20F
        for <ceph-devel@vger.kernel.org>; Wed, 22 Feb 2023 12:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1677067990;
        bh=SFRN64GHin0735rT8Zsk0sZfre5Yw+96YC5Pj5qy6fU=;
        h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type;
        b=FMYLYgUZIgH4bPFCOBiCsMDAf0hNN4Yh119axBVTixmQXPBESpPgVEjYbWcF/ei0P
         mjIlnVdKrWzz66UvjW843FzuW/6ufHdfUKLW8+wo1ziR86jcqUiWGCQivbpeYmSicn
         lZq1Z3euyXFehyKmXP1Y5oLqHKG4WEh0lR1X3okDDaYC1n2yI9Bu6N9XJnTaTyVMvU
         coC4fNHWdeIq9Xmo1TkDeuzms0PUho38/xgapTPYCYQFuk6No+ch53CLrHzfnLoc3s
         E7fX3s5olIzd0+2FKZWt4aTbIjVZ8FXH9ksM6aRxkF8rW+YD6OIusUokK60ktotsbG
         a/LkXYeep+u4g==
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-536be78056eso65674147b3.1
        for <ceph-devel@vger.kernel.org>; Wed, 22 Feb 2023 04:13:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SFRN64GHin0735rT8Zsk0sZfre5Yw+96YC5Pj5qy6fU=;
        b=zvcsxdOBxdQVS6YDMg9Pg0++rpWjPLZ/u0arhk5NeibuGnvGvnUE2AamPyT8IFpbgN
         MFVO+thaMFkzl+PSuqd7vPK4YgiwenRYuzylsVDfBLuiRB2gnDbU0dS+LDMzTQWK2oWh
         cn7u9FxcQ00tyX1gs8dgtpzjz27MQGPOgulQTXxZG7lRQixXyS3cSXMHC2Vc1ZaEAeJ5
         XD6UhyWzKqEISm9C9+Ft0nPWICI5KfWafYc4trhAqHBrEpYv1EDauwHubKJpWR6fCFnb
         2xeZHXPwVPnwFHN7Sgw17o3EKmIJnS0AMsJzaiYEFyoS3nsX+1QCETS8Hw1b8ZXwj4Xl
         ydTw==
X-Gm-Message-State: AO0yUKWyQ2IJiFELpP+Ont9XYCYZHRAS1ae4dH+XhWFrXM5azlmvik05
        RYtAckbnN+Zcp56Lra2VQ0MreruM0GbHfmRttWsIDmz9d21mL0ABmHUGUK//QX5VrweGw7/0XB5
        yrc8pnUTCvrhsWOoxZkjkEzRuEB0CFWJKjSaFOCHU0RUm1ymj25PsSr8vrudFMdo=
X-Received: by 2002:a81:4fd2:0:b0:527:9c7a:3493 with SMTP id d201-20020a814fd2000000b005279c7a3493mr1313322ywb.373.1677067988827;
        Wed, 22 Feb 2023 04:13:08 -0800 (PST)
X-Google-Smtp-Source: AK7set8fdopsNMX15qoMz5cvyNYQzcvTJ19CUinZy9ioLuvXrWyVsQKkXpRWbUQ3SV80u+9MGp0Hdll/2Py0eVDSqvQ=
X-Received: by 2002:a81:4fd2:0:b0:527:9c7a:3493 with SMTP id
 d201-20020a814fd2000000b005279c7a3493mr1313319ywb.373.1677067988556; Wed, 22
 Feb 2023 04:13:08 -0800 (PST)
MIME-Version: 1.0
From:   Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Wed, 22 Feb 2023 13:12:57 +0100
Message-ID: <CAEivzxdru7eW=DZ=UaSuisa5X2_HHtwfT-_q3+-YmpAty+p-dw@mail.gmail.com>
Subject: EBLOCKLISTED error after rbd map was interrupted by fatal signal
To:     ceph-devel@vger.kernel.org
Cc:     =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi folks,

Recently we've met a problem [1] with the kernel ceph client/rbd.

Writing to /sys/bus/rbd/add_single_major in some cases can take a lot
of time, so on the userspace side
we had a timeout and sent a fatal signal to the rbd map process to
interrupt the process.
And this working perfectly well, but then it's impossible to perform
rbd map again cause we are always getting EBLOCKLISTED error.

We've done some brief analysis of the kernel side.

Kernelside call stack:
sysfs_write [/sys/bus/rbd/add_single_major]
add_single_major_store
do_rbd_add
rbd_add_acquire_lock
rbd_acquire_lock
rbd_try_acquire_lock <- EBLOCKLISTED comes from there for 2nd and
further attempts

Most probably the place at which it was interrupted by a signal:
static int rbd_add_acquire_lock(struct rbd_device *rbd_dev)
{
...

        rbd_assert(!rbd_is_lock_owner(rbd_dev));
        queue_delayed_work(rbd_dev->task_wq, &rbd_dev->lock_dwork, 0);
        ret = wait_for_completion_killable_timeout(&rbd_dev->acquire_wait,
        ceph_timeout_jiffies(rbd_dev->opts->lock_timeout)); <=== signal arrives

As far as I understand, we had been receiving the EBLOCKLISTED errno
because ceph_monc_blocklist_add()
sent the "osd blocklist add" command to the ceph monitor successfully.
We had removed the client from blocklist [2].
But we still weren't able to perform the rbd map. It looks like some
extra state is saved on the kernel client side and blocks us.

What do you think about it?

Links:
[1] https://github.com/lxc/lxd/pull/11213
[2] https://docs.ceph.com/en/quincy/cephfs/eviction/#advanced-un-blocklisting-a-client

Kind regards,
Alex
