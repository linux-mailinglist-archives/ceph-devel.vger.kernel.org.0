Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3824CBB4
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Jun 2019 12:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfFTKYR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Jun 2019 06:24:17 -0400
Received: from mga03.intel.com ([134.134.136.65]:55912 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726081AbfFTKYR (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 20 Jun 2019 06:24:17 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 03:24:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,396,1557212400"; 
   d="scan'208";a="358487338"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.145])
  by fmsmga005.fm.intel.com with ESMTP; 20 Jun 2019 03:24:12 -0700
Received: from andy by smile with local (Exim 4.92)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1hduEk-0007HN-VY; Thu, 20 Jun 2019 13:24:10 +0300
Date:   Thu, 20 Jun 2019 13:24:10 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org,
        idryomov@gmail.com, zyan@redhat.com, sage@redhat.com,
        agruenba@redhat.com, joe@perches.com, pmladek@suse.com,
        rostedt@goodmis.org, geert+renesas@glider.be
Subject: Re: [PATCH v2 0/3] ceph: don't NULL terminate virtual xattr values
Message-ID: <20190620102410.GT9224@smile.fi.intel.com>
References: <20190619164528.31958-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619164528.31958-1-jlayton@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jun 19, 2019 at 12:45:25PM -0400, Jeff Layton wrote:
> v2: drop bogus EXPORT_SYMBOL of static function
> 
> The only real difference between this set and the one I sent originally
> is the removal of a spurious EXPORT_SYMBOL in the snprintf patch.
> 
> I'm mostly sending this with a wider cc list in an effort to get a
> review from the maintainers of the printf code. Basically ceph needs a
> snprintf variant that does not NULL terminate in order to handle its
> virtual xattrs.
> 

> Joe Perches had expressed some concerns about stack usage in vsnprintf
> with this, but I'm not sure I really understand the basis of that
> concern. If it is problematic, then I could use suggestions as to how
> best to fix that up.

It might be problematic, since vsnprintf() can be called recursively.

> ----------------------------8<-----------------------------
> 
> kcephfs has several "virtual" xattrs that return strings that are
> currently populated using snprintf(), which always NULL terminates the
> string.
> 
> This leads to the string being truncated when we use a buffer length
> acquired by calling getxattr with a 0 size first. The last character
> of the string ends up being clobbered by the termination.

So, then don't use snprintf() for this, simple memcpy() designed for that kind
of things.

> The convention with xattrs is to not store the termination with string
> data, given that we have the length. This is how setfattr/getfattr
> operate.

Fine.

> This patch makes ceph's virtual xattrs not include NULL termination
> when formatting their values. In order to handle this, a new
> snprintf_noterm function is added, and ceph is changed over to use
> this to populate the xattr value buffer.

In terms of vsnprintf(), and actually compiler point of view, it's not a string
anymore, it's a text-based data.

Personally, I don't see an advantage of a deep intrusion into vsnprintf().
The wrapper can be made to achieve this w/o touching the generic code. Thus,
you can quickly and cleanly fix the issue, while discussing this with wider
audience.

> Finally, we fix ceph to
> return -ERANGE properly when the string didn't fit in the buffer.
> 
> Jeff Layton (3):
>   lib/vsprintf: add snprintf_noterm
>   ceph: don't NULL terminate virtual xattr strings
>   ceph: return -ERANGE if virtual xattr value didn't fit in buffer
> 
>  fs/ceph/xattr.c        |  49 +++++++-------
>  include/linux/kernel.h |   2 +
>  lib/vsprintf.c         | 144 ++++++++++++++++++++++++++++-------------
>  3 files changed, 129 insertions(+), 66 deletions(-)
> 
> -- 
> 2.21.0
> 

-- 
With Best Regards,
Andy Shevchenko


