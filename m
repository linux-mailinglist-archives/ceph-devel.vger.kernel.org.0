Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58985481A7A
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Dec 2021 08:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236918AbhL3HqD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 Dec 2021 02:46:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbhL3HqC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 30 Dec 2021 02:46:02 -0500
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A752C061574
        for <ceph-devel@vger.kernel.org>; Wed, 29 Dec 2021 23:46:02 -0800 (PST)
Received: by mail-ua1-x930.google.com with SMTP id u6so33872564uaq.0
        for <ceph-devel@vger.kernel.org>; Wed, 29 Dec 2021 23:46:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=brCgIhGGKVXQcLqAxb8doE9ODkOYUkIpf7n+K48ncdk=;
        b=aUPgoTpj+Yvz1jpd9SXGFlbiCwNODOAfoBzwBKCCLFfsiwAhmc3niRtRVV6DUyU0UE
         eN01Cc91mf9EO+5fE7aZ97SjVpNXkeiOYgu0J54S4egq0kXxFg7ah6MbHmu7oZR2C0cJ
         Fja3L/XeMDkkh8HfLS5n2N9nqTKma8nSDGYUegq0fSolTdSy/RpH+FRYPWOnaP61TyK3
         38MbOoV9JZNWAvyz/BWUM8HeF9kdLJcE+glMdW6hev0RytOh5Tg0ApDB3Q3vw8kLT8Fe
         s3bF/MMm0P+V+TUphPILz594WJtVeLzy1Qo95tZSI8Os6qrFvzOvfSWMkf8njpCZLLm5
         nnzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=brCgIhGGKVXQcLqAxb8doE9ODkOYUkIpf7n+K48ncdk=;
        b=JTtxrdIoUveC0BYBJIb369HCpYDRuf7PMRZY+d6Aeo2RsEOJ/yI+BXTnyrsed9Hmwt
         5aOQgSvb8A+GufqOgrSLY4Btf4OEHDuquo5o6wzkcKUvYqSHqEy00VZWpJyWA5n9+6oy
         qYajpYvPg0xDqIjp1+3ysSme6mYh+QrvYDf1NoHNQaHerU+v6yCqAlChXV1hwgkZAuFX
         ivxpjNxLHfSCY/uh2GnrP1Tr5JDAaQXZSGimvWR6CqT7bPTrVsUO1AOMNQPljiWDxMVX
         sheq+45BZClk1O9n1DtMqN/voXTfF0BLk6MpHtr+3IKq2PWEDUB0Kt3vyRgRegRvjJqT
         a+sQ==
X-Gm-Message-State: AOAM533xxxBLJc6VJO7yULt1mYWOxizQ54TnQGCg23goa8IX3Ych3Kwl
        W66+Mjhpo0xIS2ekDGLmLIUOwFQokoVxixAMQWGemWYYw6o=
X-Google-Smtp-Source: ABdhPJxjglMWgL6BUzUJDCqy2/di0lC65PexO1MA/2y5mAlVj1hr1laTC79fTV2CcBHfr0wxFG2jlwTXhIFiU6BBwpg=
X-Received: by 2002:a67:efd3:: with SMTP id s19mr9229914vsp.36.1640850361553;
 Wed, 29 Dec 2021 23:46:01 -0800 (PST)
MIME-Version: 1.0
From:   WeiGuo Ren <rwg1335252904@gmail.com>
Date:   Thu, 30 Dec 2021 15:45:51 +0800
Message-ID: <CAPy+zYX5QYk__J7hO3U6V9ut7_LzjX6pz6Xg-79ZS_TpgPSOYQ@mail.gmail.com>
Subject: s3test: In teuthology , test_bucket_list_return_data_versioning is failed?
To:     Ceph Development <ceph-devel@vger.kernel.org>, ceph-users@ceph.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi, cepher:
when test s3tests_boto3.functional.test_s3.test_bucket_list_return_data_versioning
case ,It reported an error.
it saied:
AttributeError: 'list' object has no attribute 'replace' .
packeages:
PyYAML-6.0 boto-2.49.0 boto3-1.20.26 botocore-1.23.26
certifi-2021.10.8 charset-normalizer-2.0.9 gevent-21.12.0
greenlet-1.1.2 httplib2-0.20.2 idna-3.3 isodate-0.6.1 jmespath-0.10.0
lxml-4.7.1 munch-2.5.0 nose-1.3.7 pyparsing-3.0.6
python-dateutil-2.8.2 pytz-2021.3 requests-2.26.0 s3transfer-0.5.0
six-1.16.0 urllib3-1.26.7 zope.event-4.5.0 zope.interface-5.4.0
Have you encountered the same problem again? Can anyone help me?
