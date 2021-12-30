Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D60B481A7D
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Dec 2021 08:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbhL3HrC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 Dec 2021 02:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbhL3HrC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 30 Dec 2021 02:47:02 -0500
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF9BC061574
        for <ceph-devel@vger.kernel.org>; Wed, 29 Dec 2021 23:47:02 -0800 (PST)
Received: by mail-ua1-x92c.google.com with SMTP id i5so26221358uaq.10
        for <ceph-devel@vger.kernel.org>; Wed, 29 Dec 2021 23:47:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=3Oc+8azoZQucx7AWHCwtROPiXTWaa+tl6yNqIjwUpRc=;
        b=cjyUsOz9HInfq3vdjvG77dTYurgM85c+ws4jwyE7aGrGTFreq7DIWRUTENfuCHVyqo
         cAnjsUL8wg5nIsVwcc1CDX8RiZoOM+MmdLbmjoUM/NRvonErOaFRP4L0gwvzLFi6fNk2
         d5FSwI/MWYGog9ruKN4LdMBUv5Au+U+yw1zzaJDeCQ5uePyhNxHXtjf5lQKySg98f/bM
         V7qj5bb0noFEPNzmnQtXGB6fN6iEB6ZPEW5Xj+SZ6sdsJT7RfyzU5d3/Ty/EWBwhmDqw
         UAtLmqNC6tGOUioKnyX/l7pDduDtEEstY9tNoCBTJnXE1FMl+BqQ4/8l6+SOGqpBsIjf
         XV8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=3Oc+8azoZQucx7AWHCwtROPiXTWaa+tl6yNqIjwUpRc=;
        b=qT3Kq+KlUzZRN4ahz0V7P5oJjasY7XMg95UjLelyDjayiROUfYwGL/erBEnYSAVqQU
         0Y3CopwnQVRycjq8V1erjWmv2d7LYpmtMau1yvB9+vvduBHQVj3t5PVb3R0npPV6eIxk
         iopyK8rPN6ariM86S8mUEwg1O/9zUO590jklCjC6pAe/gvj4miJo421fJy7dQwL8oLR+
         Ug+zAG0VdIXXAyxsY1pUfTBf23tRw9uJ4LKP2UXtq/vAx9Kw4BypXyjw3Yp4xXuqD//d
         3ZWJJeZTvlDkLKK5Axe2aOum3WvSiP3Jen1SJ4ilBQLL3UP+pyesX8vw6sFCCdcXzKUI
         hZaQ==
X-Gm-Message-State: AOAM531msxxusj+JSBu2k1ubo0bFXunRfgKC227XdFrmGQDMNhN0MTdi
        2USzv5OLzGJrbJvw9Tnag1MjZ3k5kSrzH45q3pynmcHAAEs=
X-Google-Smtp-Source: ABdhPJymN6qGj3ttJqTo7u5p3fejP75StnUDnAB5MpLLzY/l0oywS8E11nBai9p+3+YJhl3jMgCdqE4l4lGtJAGKw4Y=
X-Received: by 2002:a05:6102:508c:: with SMTP id bl12mr8932851vsb.81.1640850421157;
 Wed, 29 Dec 2021 23:47:01 -0800 (PST)
MIME-Version: 1.0
References: <CAPy+zYX5QYk__J7hO3U6V9ut7_LzjX6pz6Xg-79ZS_TpgPSOYQ@mail.gmail.com>
In-Reply-To: <CAPy+zYX5QYk__J7hO3U6V9ut7_LzjX6pz6Xg-79ZS_TpgPSOYQ@mail.gmail.com>
From:   WeiGuo Ren <rwg1335252904@gmail.com>
Date:   Thu, 30 Dec 2021 15:46:51 +0800
Message-ID: <CAPy+zYX5PcKnNYQA+YzhmBpFToOjRiiq999fC=pzqF9iFMDUWA@mail.gmail.com>
Subject: Re: s3test: In teuthology , test_bucket_list_return_data_versioning
 is failed?
To:     Ceph Development <ceph-devel@vger.kernel.org>, ceph-users@ceph.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Descrition: https://github.com/ceph/s3-tests/issues/423

WeiGuo Ren <rwg1335252904@gmail.com> =E4=BA=8E2021=E5=B9=B412=E6=9C=8830=E6=
=97=A5=E5=91=A8=E5=9B=9B 15:45=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi, cepher:
> when test s3tests_boto3.functional.test_s3.test_bucket_list_return_data_v=
ersioning
> case ,It reported an error.
> it saied:
> AttributeError: 'list' object has no attribute 'replace' .
> packeages:
> PyYAML-6.0 boto-2.49.0 boto3-1.20.26 botocore-1.23.26
> certifi-2021.10.8 charset-normalizer-2.0.9 gevent-21.12.0
> greenlet-1.1.2 httplib2-0.20.2 idna-3.3 isodate-0.6.1 jmespath-0.10.0
> lxml-4.7.1 munch-2.5.0 nose-1.3.7 pyparsing-3.0.6
> python-dateutil-2.8.2 pytz-2021.3 requests-2.26.0 s3transfer-0.5.0
> six-1.16.0 urllib3-1.26.7 zope.event-4.5.0 zope.interface-5.4.0
> Have you encountered the same problem again? Can anyone help me?
