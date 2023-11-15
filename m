Return-Path: <ceph-devel+bounces-93-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 316E77EC2F2
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Nov 2023 13:51:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E061F280FC9
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Nov 2023 12:51:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E5ED156FE;
	Wed, 15 Nov 2023 12:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IJ12TYT9"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E151A5A2
	for <ceph-devel@vger.kernel.org>; Wed, 15 Nov 2023 12:51:30 +0000 (UTC)
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A042718F
	for <ceph-devel@vger.kernel.org>; Wed, 15 Nov 2023 04:51:27 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id 2adb3069b0e04-5079f9ec8d9so897991e87.0
        for <ceph-devel@vger.kernel.org>; Wed, 15 Nov 2023 04:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700052685; x=1700657485; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qRSltMozOYtYVuAQiP+QsEBk+AhAU/voS+7++D9I28o=;
        b=IJ12TYT9eNqUrMF4rC80qx5dD7FlHw6QsEtWjqVdHXr2+e1FLbG3Sw2mS48W7c+r3R
         sLS8PY2qhP6/PlJqEvh/glQnIYdxkM8z6a7nowpv/feNHpw1FsQs11xr+1T+K9Kbucnc
         juS2XuIN/YkrNJyv0VWtPrO4IkBd8xY//shQX8kFBT+gZ1nUNN5ierm04YUYvCqeeAZo
         9GcWyoRkus+8aTmATwl/mFgCCE83pDvr3rJ7DJzFo47hr4uUxLdPsO3nYvyEccpKllKM
         1jfg1J3dMObQMhDDg0DdGR1GqaEaK39QZMjWqX5dBQbUSArY6PIbCXCs+t7QRA/z135B
         2itg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700052685; x=1700657485;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qRSltMozOYtYVuAQiP+QsEBk+AhAU/voS+7++D9I28o=;
        b=XgcKLJVA/0cCYZ2YQgRTVSgPxM++g6NQe/ICIACHCle2EGx7Y6bFoSvaDBx6OqGSHu
         k2JFJhlgUPDpA8FLeXySP64lRvFHgWbgnrVb978sns9uK3nHxsJS5PzPz7KCVR7fYDY6
         nmk68BZKJcc80F38VFGFWAVVlrfxqXuDH1E0HTACpz10Q54qo8sEvLMLsPm8f/YmCUHq
         SxHz7ZT+o19lEEwDpCkSdPTYnOgXnjqDppq2Uumw4XbJgrqoW+t9QRabaf7R/QNfMHij
         REles351HZ0mUHjF6CHaR2X+ngQgyWxIPMBVBHu1w38rFMuOXEP1uP/85cvfAUsHdIYB
         N9MQ==
X-Gm-Message-State: AOJu0YxuRBmk068ABEeO3uJtE2deMOkksmKqG4EMccKSbVJKZsqVHk3B
	u2gXl4ruUv93BucJ94TPivscuG5Vy/UlLLnKXnxcXuRLQa4=
X-Google-Smtp-Source: AGHT+IGiXcDI+126rLfiadvvohFCAk7cCcXpSD9XovxrGBD5Hyn1fkJavspKmTtzJFyohm5ZCbuYE3lNH12zKY7epoA=
X-Received: by 2002:a19:7613:0:b0:504:7d7e:78dd with SMTP id
 c19-20020a197613000000b005047d7e78ddmr1853880lff.23.1700052685419; Wed, 15
 Nov 2023 04:51:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: by 2002:a05:6022:a109:b0:48:22ef:cc50 with HTTP; Wed, 15 Nov 2023
 04:51:25 -0800 (PST)
From: Judicial system <wewizdir@gmail.com>
Date: Wed, 15 Nov 2023 07:51:25 -0500
Message-ID: <CALv5U--3XScbh_GtwjLXpprdrFKO6+729jnDnYr2JyyMbAVcNw@mail.gmail.com>
Subject: We hold processed your demand among urgency. An instant dinner dress
 reply ones obtainable on behalf of your perusal.
To: ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Level: *

Your request possesses existed tackled, together with an instant reply
happens obtainable. ReconSIderation he at your earliest convenience.
https://vaok-qxqq.us21.list-manage.com/track/click?u=9b882a29c7ab3b3f6381abd18&id=56bb8add24&e=4fba4902f9x

