Return-Path: <ceph-devel+bounces-3362-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 15752B1DFC1
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Aug 2025 01:18:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D796A18A3E53
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Aug 2025 23:19:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C244242D6E;
	Thu,  7 Aug 2025 23:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T+41vqLp"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A3E22DA15
	for <ceph-devel@vger.kernel.org>; Thu,  7 Aug 2025 23:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754608717; cv=none; b=q4gxrPT8ZzWIcp1oCHtV8JVjaTB7ahgD4wZeo9fkTGL9eyaytdFkHpMnF6vjhpmkcOicHY4ct7JiTMWRXLU2T6s6268scP7wp1u1m7KJoyY1QQI8Cfr0Q+x/5WOtnuHs6lqU04oc4LAA0qzZ2/b+cw385vJ0hlL9NCKwcoJ+52A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754608717; c=relaxed/simple;
	bh=MxJfQHwhMuDzWAZl6LdP6hx/O45rVNNYxYyZKqQA+qs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=nVgvy1d5GbZjJaRbnue/g5UF286dO0LvbiIJDdkhz+0aE6zYeoPSODv7InyG4uCgSqyU4xA+nbUFdWg3S4ESn20YJKCXoCwM7MtSHBnLSeZvZfHZfSNLDrGAPoK1Nd4Ivehwhh2PJiB3bR3CvKopJO5l1/Ag02ed2XjxUO+T1S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T+41vqLp; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754608716; x=1786144716;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=MxJfQHwhMuDzWAZl6LdP6hx/O45rVNNYxYyZKqQA+qs=;
  b=T+41vqLpZfjWpsNHh7iL1M5YlFcfRk2kKhruCfffemqqUCEDtXTQ1+zt
   nUymNhmcnNWu7InkflJwTLXn/KIcef0AweCqZPjsc/C6FbAbyKV5GKnWD
   f/ck80Gvo6uJA1zicHAjSNCrX8zAxOpxmVttC+dSHusTO/yvhhGngliIT
   RR4eL2C3g+soxifjlZht6Hnm0RQ8oap/09iCwsziYM/+JTDTsHRGtPQu1
   xGkwwrGsjhoyL8i3vqe3YC6Gwn/M77nVQxR+08bLBTdUqj9Ys2qPXS+ir
   jH2hFteEYqmXnEfPeyupaIceYkAHf3HYi9+/A1Uj5GASASoQOxxfd+Kbe
   w==;
X-CSE-ConnectionGUID: 6WkJaTc5TECkqOmX2sPmhg==
X-CSE-MsgGUID: +Kdu9Ty5Qoe8coLGkbiOVw==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="68329151"
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="68329151"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 16:18:35 -0700
X-CSE-ConnectionGUID: bTX84QY0SauZcd4pgRG0pw==
X-CSE-MsgGUID: 2tgrJutcQgWj/oLor+7moA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="188856220"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa002.fm.intel.com with ESMTP; 07 Aug 2025 16:18:34 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uk9sV-0003LW-2R;
	Thu, 07 Aug 2025 23:18:31 +0000
Date: Fri, 8 Aug 2025 07:18:07 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	ceph-devel@vger.kernel.org
Subject: [ceph-client:tls-tracing-only 10/14] lib/rtlog/rtlog_des.c:22:
 warning: Function parameter or struct member 'buffer' not described in
 'rtlog_des_get_u32'
Message-ID: <202508080748.1UpqZMm5-lkp@intel.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/ceph/ceph-client.git tls-tracing-only
head:   ffad14ce035a047cbfda2d38f7ae37b0767de136
commit: 310aa14b5bf4d5ecd1abf6a00782e044f7d76940 [10/14] ceph integration
config: hexagon-allyesconfig (https://download.01.org/0day-ci/archive/20250808/202508080748.1UpqZMm5-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 7b8dea265e72c3037b6b1e54d5ab51b7e14f328b)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250808/202508080748.1UpqZMm5-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508080748.1UpqZMm5-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> lib/rtlog/rtlog_des.c:22: warning: Function parameter or struct member 'buffer' not described in 'rtlog_des_get_u32'
>> lib/rtlog/rtlog_des.c:22: warning: Function parameter or struct member 'buf_end' not described in 'rtlog_des_get_u32'
>> lib/rtlog/rtlog_des.c:22: warning: Function parameter or struct member 'value' not described in 'rtlog_des_get_u32'
>> lib/rtlog/rtlog_des.c:38: warning: Function parameter or struct member 'buffer' not described in 'rtlog_des_get_u64'
>> lib/rtlog/rtlog_des.c:38: warning: Function parameter or struct member 'buf_end' not described in 'rtlog_des_get_u64'
>> lib/rtlog/rtlog_des.c:38: warning: Function parameter or struct member 'value' not described in 'rtlog_des_get_u64'
>> lib/rtlog/rtlog_des.c:54: warning: Function parameter or struct member 'buffer' not described in 'rtlog_des_get_ptr'
>> lib/rtlog/rtlog_des.c:54: warning: Function parameter or struct member 'buf_end' not described in 'rtlog_des_get_ptr'
>> lib/rtlog/rtlog_des.c:54: warning: Function parameter or struct member 'value' not described in 'rtlog_des_get_ptr'
>> lib/rtlog/rtlog_des.c:71: warning: Function parameter or struct member 'buffer' not described in 'rtlog_des_get_string'
>> lib/rtlog/rtlog_des.c:71: warning: Function parameter or struct member 'buf_end' not described in 'rtlog_des_get_string'
>> lib/rtlog/rtlog_des.c:71: warning: Function parameter or struct member 'out' not described in 'rtlog_des_get_string'
>> lib/rtlog/rtlog_des.c:71: warning: Function parameter or struct member 'out_size' not described in 'rtlog_des_get_string'
>> lib/rtlog/rtlog_des.c:118: warning: Function parameter or struct member 'fmt' not described in 'rtlog_des_reconstruct'
>> lib/rtlog/rtlog_des.c:118: warning: Function parameter or struct member 'buffer' not described in 'rtlog_des_reconstruct'
>> lib/rtlog/rtlog_des.c:118: warning: Function parameter or struct member 'nr_args' not described in 'rtlog_des_reconstruct'
>> lib/rtlog/rtlog_des.c:118: warning: Function parameter or struct member 'size' not described in 'rtlog_des_reconstruct'
>> lib/rtlog/rtlog_des.c:118: warning: Function parameter or struct member 'out' not described in 'rtlog_des_reconstruct'
>> lib/rtlog/rtlog_des.c:118: warning: Function parameter or struct member 'out_size' not described in 'rtlog_des_reconstruct'
>> lib/rtlog/rtlog_des.c:391: warning: Function parameter or struct member 'entry' not described in 'rtlog_log_reconstruct'
   lib/rtlog/rtlog_des.c:391: warning: Function parameter or struct member 'output' not described in 'rtlog_log_reconstruct'
   lib/rtlog/rtlog_des.c:391: warning: Function parameter or struct member 'output_size' not described in 'rtlog_log_reconstruct'


vim +22 lib/rtlog/rtlog_des.c

    17	
    18	/**
    19	 * rtlog_des_get_u32 - Extract a 32-bit integer from binary buffer
    20	 */
    21	int rtlog_des_get_u32(const char **buffer, const char *buf_end, u32 *value)
  > 22	{
    23		if (*buffer + sizeof(u32) > buf_end) {
    24			pr_err("rtlog_des: buffer overrun reading u32\n");
    25			return -EFAULT;
    26		}
    27	
    28		*value = *(u32 *)(*buffer);
    29		*buffer += sizeof(u32);
    30		return 0;
    31	}
    32	EXPORT_SYMBOL_GPL(rtlog_des_get_u32);
    33	
    34	/**
    35	 * rtlog_des_get_u64 - Extract a 64-bit integer from binary buffer
    36	 */
    37	int rtlog_des_get_u64(const char **buffer, const char *buf_end, u64 *value)
  > 38	{
    39		if (*buffer + sizeof(u64) > buf_end) {
    40			pr_err("rtlog_des: buffer overrun reading u64\n");
    41			return -EFAULT;
    42		}
    43	
    44		*value = *(u64 *)(*buffer);
    45		*buffer += sizeof(u64);
    46		return 0;
    47	}
    48	EXPORT_SYMBOL_GPL(rtlog_des_get_u64);
    49	
    50	/**
    51	 * rtlog_des_get_ptr - Extract a pointer from binary buffer
    52	 */
    53	int rtlog_des_get_ptr(const char **buffer, const char *buf_end, unsigned long *value)
  > 54	{
    55		if (*buffer + sizeof(unsigned long) > buf_end) {
    56			pr_err("rtlog_des: buffer overrun reading pointer\n");
    57			return -EFAULT;
    58		}
    59	
    60		*value = *(unsigned long *)(*buffer);
    61		*buffer += sizeof(unsigned long);
    62		return 0;
    63	}
    64	EXPORT_SYMBOL_GPL(rtlog_des_get_ptr);
    65	
    66	/**
    67	 * rtlog_des_get_string - Extract a string from the binary buffer
    68	 */
    69	int rtlog_des_get_string(const char **buffer, const char *buf_end, 
    70				 char *out, size_t out_size)
  > 71	{
    72		const char *str = *buffer;
    73		size_t str_len;
    74		size_t max_scan_len;
    75		size_t padded_len;
    76	
    77		if (*buffer >= buf_end) {
    78			pr_err("rtlog_des: buffer overrun at string argument\n");
    79			return -EFAULT;
    80		}
    81	
    82		/* Calculate maximum safe length to scan for null terminator */
    83		max_scan_len = buf_end - *buffer;
    84	
    85		/* Find string length with bounds checking */
    86		str_len = strnlen(str, max_scan_len);
    87		if (str_len == max_scan_len && str[str_len - 1] != '\0') {
    88			pr_err("rtlog_des: unterminated string in buffer\n");
    89			return -EFAULT;
    90		}
    91	
    92		/* Advance buffer pointer with proper alignment */
    93		padded_len = round_up(str_len + 1, 4);
    94		*buffer += padded_len;
    95	
    96		/* Check if buffer advance exceeds entry bounds */
    97		if (*buffer > buf_end) {
    98			pr_err("rtlog_des: string extends beyond buffer bounds\n");
    99			return -EFAULT;
   100		}
   101	
   102		/* Copy string to output with bounds checking */
   103		if (str_len >= out_size)
   104			str_len = out_size - 1;
   105		
   106		memcpy(out, str, str_len);
   107		out[str_len] = '\0';
   108	
   109		return 0;
   110	}
   111	EXPORT_SYMBOL_GPL(rtlog_des_get_string);
   112	
   113	/**
   114	 * rtlog_des_reconstruct - Reconstruct formatted string from binary data
   115	 */
   116	int rtlog_des_reconstruct(const char *fmt, const void *buffer, size_t nr_args,
   117				  size_t size, char *out, size_t out_size)
 > 118	{
   119		const char *buf_start = (const char *)buffer;
   120		const char *buf_ptr = buf_start;
   121		const char *buf_end = buf_start + size;
   122		const char *fmt_ptr = fmt;
   123		char *out_ptr = out;
   124		size_t remaining = out_size - 1; /* Reserve space for null terminator */
   125		size_t arg_count = 0;
   126		int ret;
   127	
   128		if (!fmt || !buffer || !out || !out_size) {
   129			pr_err("rtlog_des_reconstruct: invalid parameters\n");
   130			return -EINVAL;
   131		}
   132	
   133		*out_ptr = '\0';
   134	
   135		/* Process the format string */
   136		while (*fmt_ptr && remaining > 0) {
   137			if (*fmt_ptr != '%') {
   138				/* Copy literal character */
   139				*out_ptr++ = *fmt_ptr++;
   140				remaining--;
   141				continue;
   142			}
   143	
   144			/* Skip the '%' */
   145			fmt_ptr++;
   146	
   147			/* Handle %% */
   148			if (*fmt_ptr == '%') {
   149				*out_ptr++ = '%';
   150				fmt_ptr++;
   151				remaining--;
   152				continue;
   153			}
   154	
   155			/* Skip flags, width, precision modifiers */
   156			while (*fmt_ptr && (*fmt_ptr == '-' || *fmt_ptr == '+' || 
   157					   *fmt_ptr == '#' || *fmt_ptr == '0' || 
   158					   *fmt_ptr == ' ')) {
   159				fmt_ptr++;
   160			}
   161	
   162			while (*fmt_ptr && (*fmt_ptr >= '0' && *fmt_ptr <= '9')) {
   163				fmt_ptr++;
   164			}
   165			if (*fmt_ptr == '*') {
   166				fmt_ptr++;
   167			}
   168	
   169			if (*fmt_ptr == '.') {
   170				fmt_ptr++;
   171				while (*fmt_ptr && (*fmt_ptr >= '0' && *fmt_ptr <= '9')) {
   172					fmt_ptr++;
   173				}
   174				if (*fmt_ptr == '*') {
   175					fmt_ptr++;
   176				}
   177			}
   178	
   179			/* Check argument count limit */
   180			if (arg_count >= nr_args) {
   181				pr_err("rtlog_des_reconstruct: too many format specifiers\n");
   182				return -EINVAL;
   183			}
   184	
   185			/* Parse and handle format specifier */
   186			switch (*fmt_ptr) {
   187			case 's': { /* String */
   188				char str_buf[256];
   189				ret = rtlog_des_get_string(&buf_ptr, buf_end, str_buf, sizeof(str_buf));
   190				if (ret) 
   191					return ret;
   192	
   193				ret = snprintf(out_ptr, remaining, "%s", str_buf);
   194				if (ret > 0) {
   195					if (ret > remaining)
   196						ret = remaining;
   197					out_ptr += ret;
   198					remaining -= ret;
   199				}
   200				break;
   201			}
   202	
   203			case 'd': case 'i': { /* Integer */
   204				u32 val;
   205				ret = rtlog_des_get_u32(&buf_ptr, buf_end, &val);
   206				if (ret)
   207					return ret;
   208	
   209				ret = snprintf(out_ptr, remaining, "%d", (int)val);
   210				if (ret > 0) {
   211					if (ret > remaining)
   212						ret = remaining;
   213					out_ptr += ret;
   214					remaining -= ret;
   215				}
   216				break;
   217			}
   218	
   219			case 'u': { /* Unsigned integer */
   220				u32 val;
   221				ret = rtlog_des_get_u32(&buf_ptr, buf_end, &val);
   222				if (ret)
   223					return ret;
   224	
   225				ret = snprintf(out_ptr, remaining, "%u", val);
   226				if (ret > 0) {
   227					if (ret > remaining)
   228						ret = remaining;
   229					out_ptr += ret;
   230					remaining -= ret;
   231				}
   232				break;
   233			}
   234	
   235			case 'x': { /* Hex integer (lowercase) */
   236				u32 val;
   237				ret = rtlog_des_get_u32(&buf_ptr, buf_end, &val);
   238				if (ret)
   239					return ret;
   240	
   241				ret = snprintf(out_ptr, remaining, "%x", val);
   242				if (ret > 0) {
   243					if (ret > remaining)
   244						ret = remaining;
   245					out_ptr += ret;
   246					remaining -= ret;
   247				}
   248				break;
   249			}
   250	
   251			case 'X': { /* Hex integer (uppercase) */
   252				u32 val;
   253				ret = rtlog_des_get_u32(&buf_ptr, buf_end, &val);
   254				if (ret)
   255					return ret;
   256	
   257				ret = snprintf(out_ptr, remaining, "%X", val);
   258				if (ret > 0) {
   259					if (ret > remaining)
   260						ret = remaining;
   261					out_ptr += ret;
   262					remaining -= ret;
   263				}
   264				break;
   265			}
   266	
   267			case 'l': { /* Handle long types */
   268				if (*(fmt_ptr + 1) == 'l') {
   269					/* long long */
   270					fmt_ptr++; /* Skip second 'l' */
   271					switch (*(fmt_ptr + 1)) {
   272					case 'd': case 'i':
   273						fmt_ptr++; /* Skip format char */
   274						{
   275							u64 val;
   276							ret = rtlog_des_get_u64(&buf_ptr, buf_end, &val);
   277							if (ret)
   278								return ret;
   279	
   280							ret = snprintf(out_ptr, remaining, "%lld", (long long)val);
   281							if (ret > 0) {
   282								if (ret > remaining)
   283									ret = remaining;
   284								out_ptr += ret;
   285								remaining -= ret;
   286							}
   287						}
   288						break;
   289					case 'u':
   290						fmt_ptr++; /* Skip format char */
   291						{
   292							u64 val;
   293							ret = rtlog_des_get_u64(&buf_ptr, buf_end, &val);
   294							if (ret)
   295								return ret;
   296	
   297							ret = snprintf(out_ptr, remaining, "%llu", val);
   298							if (ret > 0) {
   299								if (ret > remaining)
   300									ret = remaining;
   301								out_ptr += ret;
   302								remaining -= ret;
   303							}
   304						}
   305						break;
   306					case 'x':
   307						fmt_ptr++; /* Skip format char */
   308						{
   309							u64 val;
   310							ret = rtlog_des_get_u64(&buf_ptr, buf_end, &val);
   311							if (ret)
   312								return ret;
   313	
   314							ret = snprintf(out_ptr, remaining, "%llx", val);
   315							if (ret > 0) {
   316								if (ret > remaining)
   317									ret = remaining;
   318								out_ptr += ret;
   319								remaining -= ret;
   320							}
   321						}
   322						break;
   323					default:
   324						pr_err("rtlog_des: unsupported format %%ll%c\n", *(fmt_ptr + 1));
   325						return -EINVAL;
   326					}
   327				} else {
   328					/* long */
   329					switch (*(fmt_ptr + 1)) {
   330					case 'd': case 'i': case 'u': case 'x': case 'X':
   331						fmt_ptr++; /* Skip format char */
   332						{
   333							unsigned long val;
   334							ret = rtlog_des_get_ptr(&buf_ptr, buf_end, &val);
   335							if (ret)
   336								return ret;
   337	
   338							ret = snprintf(out_ptr, remaining, "%lx", val);
   339							if (ret > 0) {
   340								if (ret > remaining)
   341									ret = remaining;
   342								out_ptr += ret;
   343								remaining -= ret;
   344							}
   345						}
   346						break;
   347					default:
   348						pr_err("rtlog_des: unsupported format %%l%c\n", *(fmt_ptr + 1));
   349						return -EINVAL;
   350					}
   351				}
   352				break;
   353			}
   354	
   355			case 'p': { /* Pointer */
   356				unsigned long val;
   357				ret = rtlog_des_get_ptr(&buf_ptr, buf_end, &val);
   358				if (ret)
   359					return ret;
   360	
   361				ret = snprintf(out_ptr, remaining, "%p", (void *)val);
   362				if (ret > 0) {
   363					if (ret > remaining)
   364						ret = remaining;
   365					out_ptr += ret;
   366					remaining -= ret;
   367				}
   368				break;
   369			}
   370	
   371			default:
   372				pr_err("rtlog_des: unsupported format specifier %%%c\n", *fmt_ptr);
   373				return -EINVAL;
   374			}
   375	
   376			fmt_ptr++;
   377			arg_count++;
   378		}
   379	
   380		/* Null terminate the output */
   381		*out_ptr = '\0';
   382		return 0;
   383	}
   384	EXPORT_SYMBOL_GPL(rtlog_des_reconstruct);
   385	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

