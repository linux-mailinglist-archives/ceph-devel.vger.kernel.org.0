Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13CC7229F5D
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Jul 2020 20:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730843AbgGVSlZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 22 Jul 2020 14:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgGVSlZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 22 Jul 2020 14:41:25 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1E2C0619DC
        for <ceph-devel@vger.kernel.org>; Wed, 22 Jul 2020 11:41:25 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id bm28so2442993edb.2
        for <ceph-devel@vger.kernel.org>; Wed, 22 Jul 2020 11:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=tmEP0SohNG29M5Jt8DWdjq3wWUlw86k9FCvdX7iITDg=;
        b=kubLmbUw83647yiFqBhziYsw5VNfMzJVfrfABCskEdfZSr52aWajfAZgIpouipAM0O
         t1+vXoB3uzGoijQHhCwUti74feAJqKAdauoiLjqyJFf91n8tTuEODDZsF4KNBY/8sP7A
         SNKzViMKgmUYhkB6K3Hd//D1SOc5YLqqjVgKpTyTMdRvgKbuhX4JbOcb2jHxj9DyhHbc
         6t2pqGUOJoy3ua50vNeK5+6AZjMf4cQBS4VRm9H1In6q9VjBgpwgSVzSrRyYqa0Gvxvk
         D2hzk7L6vPRAzVjf68B2qNgSTFehxJCSbUu3h5v6Wd5Rs0qFJ2GyNQ42kFGr6VboOQpc
         r2Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=tmEP0SohNG29M5Jt8DWdjq3wWUlw86k9FCvdX7iITDg=;
        b=pfuaG9PUMh7J45SzcgNMqLuJWRTbovdYcMR9m7hxPG7Ee8LeW+dWaKyaRcYK4+RbAb
         8miR+MLlnRfw9QYSgSqjhuyRmane0rUK0j+1+KhCT7qhMXzng0i9+9VY9KDtiOvfzn9v
         NJ7tb1s4CXoGrA4Vjn2sGc6Ud1Mg9zZkpN5L4Y6vePvPdVLAUNEvyaKAMWVh9onkUHPq
         jJGD963Fit7w2v6X9IomZ4DnLJ8KXdk7DBMMUfpF8YDfaH0S2kvazsfEruueVGYVeAUl
         bMO3B0zpuN3/V11YC28Z9Ogzyc8ikId3uqJREAhnYH6dXaGccN/uL/xa1pIhwid/Npk8
         SzpQ==
X-Gm-Message-State: AOAM532M+85yC8PVvYqLOY1TIxjd2XX6D57GIXT5vIXmqEU48KViteTz
        0NcOXrhg9+lC4GrC4QbefCxNrSdya2riag==
X-Google-Smtp-Source: ABdhPJwg1NFPBaZU5Fjo1qzcesrxiPnouSMPX+HDQZhwRGOPx54YW3G7qae89K2a3f5irs8um9zFxA==
X-Received: by 2002:a50:e385:: with SMTP id b5mr812838edm.130.1595443283454;
        Wed, 22 Jul 2020 11:41:23 -0700 (PDT)
Received: from oc4278210638.ibm.com ([2a02:8070:a1a5:8400:7e7:ba1f:70a9:f64e])
        by smtp.gmail.com with ESMTPSA id e8sm302353eja.101.2020.07.22.11.41.22
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2020 11:41:22 -0700 (PDT)
From:   Ezra Ulembeck <ulembeck@gmail.com>
To:     ceph-devel@vger.kernel.org
Subject: Problems with building/installing ceph from sources (git repo) on
 x86_64 (ubuntu 20.04)
Message-ID: <cda63c29-bf9a-635f-df95-38cd04de2ced@gmail.com>
Date:   Wed, 22 Jul 2020 20:41:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi all,

While following the instructions in
https://docs.ceph.com/docs/master/install/build-ceph/

1) I am not able to build packages
2) I encounter problems after building/installing in user-space

Details:

$ git clone --recursive https://github.com/ceph/ceph.git
$ cd ceph
$ git checkout octopus
$ ./install-deps.sh

1. Building packages

$ sudo dpkg-buildpackage -j4
...
/usr/bin/cc -g -O2 -fdebug-prefix-map=/home/eduard/ceph=. 
-fstack-protector-strong -Wformat -Werror=format-security -Wdate-time 
-D_FORTIFY_SOURCE=2 -DCMAKE_HAVE_LIBC_PTHREAD  -Wl,-Bsymbolic-functions 
-Wl,-z,relro  CMakeFiles/cmTC_277b6.dir/src.c.o  -o cmTC_277b6
/usr/bin/ld: CMakeFiles/cmTC_277b6.dir/src.c.o: in function `main':
./obj-x86_64-linux-gnu/CMakeFiles/CMakeTmp/./obj-x86_64-linux-gnu/CMakeFiles/CMakeTmp/src.c:11: 
undefined reference to `pthread_create'
/usr/bin/ld: 
./obj-x86_64-linux-gnu/CMakeFiles/CMakeTmp/./obj-x86_64-linux-gnu/CMakeFiles/CMakeTmp/src.c:12: 
undefined reference to `pthread_detach'
/usr/bin/ld: 
./obj-x86_64-linux-gnu/CMakeFiles/CMakeTmp/./obj-x86_64-linux-gnu/CMakeFiles/CMakeTmp/src.c:13: 
undefined reference to `pthread_join'
collect2: error: ld returned 1 exit status

2. Building/installing in user-space

$ ./do_cmake.sh
$ cd build
$ make
$ sudo make install

$ ceph -s
Traceback (most recent call last):
   File "/usr/local/bin/ceph", line 140, in <module>
     import rados
ImportError: librados.so.2: cannot open shared object file: No such file 
or directory


I will be very thankful for any hints on how to get to success,

Thanks,
Ezra
