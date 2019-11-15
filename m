Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A184FD979
	for <lists+ceph-devel@lfdr.de>; Fri, 15 Nov 2019 10:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfKOJk6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 15 Nov 2019 04:40:58 -0500
Received: from mail-ot1-f42.google.com ([209.85.210.42]:38544 "EHLO
        mail-ot1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfKOJk5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 15 Nov 2019 04:40:57 -0500
Received: by mail-ot1-f42.google.com with SMTP id z25so7524979oti.5
        for <ceph-devel@vger.kernel.org>; Fri, 15 Nov 2019 01:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Y8iHX3mAOQDmH2o1lw7xiic8qV1gq91jduLLMfji+7Y=;
        b=BDM6SKa0Kn3Xzvvt3euGCp51sfee2WQKI4VnUiIkqY7LSqAXNaP3yjYKmVDoTGDGI7
         VcviP6V6pWktM9TQVmP2EQgK0OKuVfzkZffr28b3w3/fUFRuPYDnQtguGOLQbH9nD7WN
         KCwFWSyn/O1FXjS3G9MbR+yOEHHSQ1yovkM510gX16Cs4hzuahgZaqTaaeOEcSc3YRV/
         Bod6OstT0pm2wBZKRl9WMy63VPjelcPzuODoVDgvkyO/K6oDAoti+6I8vwMFZunzwTeT
         EBRtL4iNeWjtqOaFLza/cmkj++FLm4K5eNDzKpUv170ExKu1dVG4l8j7SYzg3v1QKlSM
         AeMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Y8iHX3mAOQDmH2o1lw7xiic8qV1gq91jduLLMfji+7Y=;
        b=YHAG+2kfdFm8iLQ4tJvLi5SnmHhu69WZrHbG7523MN0uJnmw2m+kwBmSnHW6j8Dych
         y8/X2zx/4CVRauRAawbaHZFmpmDmK4d8GuykXnyStyeDSJD/azTMlzJLQWaFnNNHxrgR
         LQA1CEUTje4hC1b0y+keA2dd3+CzOcR+ZuQLT8EvNWy9kXCHD8PDXQ+QXD9JUgBUwSQN
         wrtk/gnoJzou2ulY311GY+HPGZLuCYwavpRazAoV/rk8uDTHpoLIl+2NBELFcczQg+5O
         haw4mxVXCxGk1t5yWA3fGRZ2LCOuawcuFvU1kEfrUYQi3aT0vUyTKRQFlCq4Uhngp/rc
         blmQ==
X-Gm-Message-State: APjAAAUrKWKnM/wSP1fOWzXX8LAt7VAq9VVP6wjUrlS5koKjPmLCbaf4
        MgDMMuvqCqrqrNcXmUAxZU9NIZiGsCTx7Iej36Jy11S2
X-Google-Smtp-Source: APXvYqw53o16LvlF2dECskBga3IjXINcfSwwaqRe13VQR4mwLxXwaUdF+wzkYMOOjodI/QT1cF47GUHK6JmCfZjAXuE=
X-Received: by 2002:a9d:5c2:: with SMTP id 60mr11257838otd.104.1573810856569;
 Fri, 15 Nov 2019 01:40:56 -0800 (PST)
MIME-Version: 1.0
From:   Xinying Song <songxinying.ftd@gmail.com>
Date:   Fri, 15 Nov 2019 17:40:45 +0800
Message-ID: <CAMWWNq_ye1ok8FcJUsaOP8pjMUQi0tOzm3ycHhKd5w+sHWAd7A@mail.gmail.com>
Subject: RGW: range copy failed with tenant enable
To:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi, everyone:

I'm using the range copy function in rgw of Luminous. I create a user
account  which is under a named tenant. When I'm trying to start a
range copy within its bucket, rgw complaints with 404. The log shows
that rgw failed to find the bucket under the empty tenant.
What's more, when I create the same name bucket using another user
account which is under an empty tenant, range copy will succeed, and
the tenanted user finally reads the content of the empty-tenant user
without any permission check fail. This problem also exists in master
branch.

The permission check in verify_permission() seems not to work for
range copy, because of the variable used in the if sentence has never
been initialized. I have tried to fix it by moving the copy-source
logic in get_params() to rgw_op::init_processing(), and it seems to
work. But I'm not sure if this is the right way.

The issue tracker is https://tracker.ceph.com/issues/42825. Any
suggestion is appreciated, thanks!
