Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80B87181576
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Mar 2020 11:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbgCKKFc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Mar 2020 06:05:32 -0400
Received: from mail-lj1-f169.google.com ([209.85.208.169]:40902 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728195AbgCKKFc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 11 Mar 2020 06:05:32 -0400
Received: by mail-lj1-f169.google.com with SMTP id 19so1609703ljj.7
        for <ceph-devel@vger.kernel.org>; Wed, 11 Mar 2020 03:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=YbUsFQAnHxQ6iOM0OWbJOZvIL9fkE204Lg8RA+PfxII=;
        b=BRODBtTviXgxr1qE7tFtP8ulIcmXuJByZDb9WjjH/50Ura6gQ3xgX8W0vvMzdkbzWl
         lr7y2gjO+kL0LrhnLg3pxJwY51ygYHFVgaVJUKUPr7H6OAFo4CySNc3s9yr0V0H2JJkh
         KUdODqRSBt0rAQInNi2PvEwXwkUJ77gkQbAg75VAprZp/ynvEAg59+yi1BDFcGCQFBaB
         ox+YkPmAj16o8rEcH07MSfKz02+scyaBl3mc1w6UbDJFn5e/Q4Bwk2Kap25rQXkELyUy
         ugRCRxnBOnvkIrSfWpSsJ/X/W2sXJoZl0bAWoOcbeDfmqObjoajnJNwiHVXWCBbv2DL4
         MyPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=YbUsFQAnHxQ6iOM0OWbJOZvIL9fkE204Lg8RA+PfxII=;
        b=gTvqjCffc8euAoDMlIlUhhcvJ7XktiaH7SWXueO5Z+lekSFgs8T3IQ/8/jw1SNoETf
         qqcg3fIu4FNe6YC0emUda/XRKV4bguwGNEAp5lbPxJDwzyhwYh0ICRRoOknYPmW0cpSS
         vdJfOqwxt+ZRN/QbecYxE9Pw8LpxruBjJ2aWK0rlc00JvGMgDe7ZkNalGytvdwmjsnAY
         rsIGj6O+Fsi0vMkIDMXXSJL8A7ESk/1d4JsP+KmgCSG6qfYlDbaVlujoZg/yUj2nWQ3V
         8pQbpr29+x7v7JbR7LxhwxaqRhYihV5YLHokwlF8EkfC4tBBy2HfPMw6eSRQBZC0coxW
         X5lg==
X-Gm-Message-State: ANhLgQ1pczjoOebzdDjI2bB2vT9qMM7hY2VIDfBn+mIUtLPvJ0uL8qYK
        WRnCD4xrD1LLvweUyWOoGoMjIrZsPykDrGyKYt9wLA==
X-Google-Smtp-Source: ADFU+vue1xzRVT9Xz8RUJPX2dMqBuf2l6yjAnLtHxaZ/jtxivyFkxkDYoZy8LiAa2wM4VgpzW9bnRg9FUSESUYPlzSs=
X-Received: by 2002:a2e:9205:: with SMTP id k5mr1688240ljg.133.1583921130035;
 Wed, 11 Mar 2020 03:05:30 -0700 (PDT)
MIME-Version: 1.0
From:   erqi chen <chenerqi@gmail.com>
Date:   Wed, 11 Mar 2020 18:05:18 +0800
Message-ID: <CA+eEYqUPNME3GGBcJY=0KX-nn8s13u7cKwj_9FLZWN7H3vz2vQ@mail.gmail.com>
Subject: ceph kernel client QoS
To:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

I want to add QoS on rbd image and cephfs directory, is there on-going
or future work for this? If no, any suggested solution=EF=BC=9F
Thanks and regards!
