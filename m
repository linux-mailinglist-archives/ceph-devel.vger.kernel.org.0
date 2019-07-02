Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD7185CDE6
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Jul 2019 12:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfGBKvv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 2 Jul 2019 06:51:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:41230 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725767AbfGBKvv (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 2 Jul 2019 06:51:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7E73DB130;
        Tue,  2 Jul 2019 10:51:49 +0000 (UTC)
From:   Sebastian Wagner <sebastian.wagner@suse.com>
Subject: New central place to put common Python code?
Openpgp: preference=signencrypt
Autocrypt: addr=swagner@suse.com; prefer-encrypt=mutual; keydata=
 mQENBFgkpqgBCACl4ZHmEEhiZiofnuiVR3wc4ZH3ty2Y7Fgv/ttDAtyQSM3l5MrwFVEkTUKW
 zZOaLPsVl8FwBoy1ciK3cS6nOKwgYogStBBqX8mvnlb915kvhtQ84bSPQ9W5206tKfQDKmZ8
 jWjgEKCwFxH3O2teG2Jc8HFVjNWeUEdF1s9OrL6s6RQmiDf7gkzZL5ew5vS0G1yIWzJBpQzS
 GJEcjm1TmnZWN1jgkKOENBzbDQcBg/IDiLDnbSpAL4LG7RAaavMMdSyVXMOGpmbgV9vNkpTw
 0qpVttsU2t919B02bLTEbYBb3Amsfy8S+ahzQgjg2xiT94xyC7ukLQI4nKEseolN9uERABEB
 AAG0I1NlYmFzdGlhbiBXYWduZXIgPHN3YWduZXJAc3VzZS5jb20+iQE7BBMBAgAlAhsDBgsJ
 CAcDAgYVCAIJCgsEFgIDAQIeAQIXgAUCWCWwgwIZAQAKCRCNJEKAfml5+CdFB/wPI/8K94em
 Zi7GvN6FwCy0Ts+CKSYJcJoX7m0Jp6i3PaTgZMjhmH+KGH/mwXAUPE1NB/Pe/iIwrhRR9tnP
 iJgFcOh4Qe64dsk1DwftVOIk+xEBPYPb6S0FDVLdRkdJUT+2/R+yQirEQACcakHHZvbGru3e
 kF+P8OPQxX6llR3kK6MUa3RX2ZlrwiLNsw4LABKSInl0wsVlzH10LaQxujaqs/NFELR7kkZx
 wd2L3uVAmNxu2XAD6h3oEabQCN6Ol9MDPwX+QZNJ6ZTT5Qofba7Vm1zA5Tmj6mMxMK4M62qu
 5ekGxgWDRmf5Sx6PPphJ1JZY/N/TqchUlpeNIxyHGGMRuQENBFgkpqgBCAC8AHCom5ZNqJhB
 Jsftllb+TTVAtGMt/2R5c+5BfRrrd8rsN7st5hG2RECaokswFHrBWsJvxTex1V+v+ctej4SQ
 64TII9Z2ffySTzdqGFWssOUrHoJvk+4BRuJ48f+bSRETGlXILqIiAISRAfeYOJIGCbsRmijx
 fMjRPzMel2TobmCBW3YsSNVLo/3cMzF7sYHDK9IiAeb9fWrG/p5brtItlfJUmsw+1aZ42TaR
 94mcjKK0U2tTtj1fGkjhb0bRNTiXMQEWIx0xAyCaR61mGpqMhRE8FJ7eY19mAl9G5zTs604I
 ToEcJ6Bd518hJ0HXFJrqKJ/TUKL/dKR4iMViFUORABEBAAGJAR8EGAECAAkFAlgkpqgCGwwA
 CgkQjSRCgH5pefiqQwf/U+POJe0SgWBzX6+69CuRUwE68Uu0qGrNWOfWphaKPksBDx46IhhA
 UlmBJbEoo9h6E7utwwgDNf92O2Lv6yClR+2D2BA9mHLm0DBsmH04bahHGsicU1qK0rBgujqc
 GNrrgYPx3z66C7MB/o6/smS26baOChtrs5XeX3r4zE5+1yZCPb9AR8pwitNF+N81FIXE0DXp
 XhxSviD3KT4QH6Oo6f1PJ3kYnHHX9FmS/3f6hDU2o/kBwOfaP2C0ZWIcbh8VH0ENWdGl6/OK
 QJO68y6QM2NCeCAvfyISE4GERtb7/oRlvtBwWfq7OBsqLXkrKobW4sdx8Scbwb728fF14Oyn 2A==
To:     "dev@ceph.io" <dev@ceph.io>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Message-ID: <8a024ee8-a50a-069b-ead8-315531a1bc20@suse.com>
Date:   Tue, 2 Jul 2019 12:51:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

All,

especially in the Ceph Orchestrator world, we're facing an issue where
we don't have a place for for Python code that can be imported by the
MGR and by tools that deploy Ceph.

Having a Library for common Python code would also provide a way to ease
some other Python related problems (also orchestrator independent):

1. There is duplicated code in the cython bindings. Especially the
Exceptions are duplicated for each binding.

2. There is no good way to share Python code between different tools
written in Pyhton

3. There is no way to share common code, like e.g. common data
structures between the different layers of the Orchestrator stacks.

4. There is no statically type-checkable Python API for the (mon)
command API.

5. The local Ceph version number is hard coded into the ceph cli binary

Now, the idea is to build a new Python package that is supposed to be
importable by everyone.

From a user's POV, this would look something like

> 
> from ceph.mon_command_api import MonCommandApi
> from ceph.deployment_utils import DriveGroupSpec
> from ceph.exceptions import Error
> 
> MonCommandApi(...).osd_pool_create(pool='my_pool', ...)
> 
> try:
>     ...
> except OSError:
>     ...

What would be the scope of this library? Basically everything where
there is a real benefit for having it included, like sharing common code
between things. From the orchestrator, this could include common
deployment recipes. Or recipes used by the SSH orchestrator.

Some open questions are:

What about code that right now lives in the dashboard, like
pybind/mgr/dashboard.controllers.rbd.Rbd#_rbd_disk_usage
for calculating the RBD disk usage?

Where does it live in the ceph git? /src/python-common/ ?

How can we package it?

Python 2?

Thanks,
Sebastian

-- 
-- 
SUSE Linux GmbH, Maxfeldstrasse 5, 90409 Nuernberg, Germany
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah, HRB 21284 (AG Nürnberg)
